#!/usr/bin/env bash
# Run on a fresh EC2 (Ubuntu 22.04/24.04 or Amazon Linux 2023).
# Exports /app/secret so the PV in pvc.yml can mount it.
#
# Usage:
#   sudo bash setup-nfs-ec2.sh
#   sudo NFS_CLIENT_CIDR=10.0.0.0/16 bash setup-nfs-ec2.sh
#
# Then put this instance's private IP in pvc.yml under spec.nfs.server
# and open TCP 2049 (and TCP/UDP 111) from your Kubernetes nodes' security group.

set -euo pipefail

EXPORT_PATH="${EXPORT_PATH:-/app/secret}"
NFS_CLIENT_CIDR="${NFS_CLIENT_CIDR:-*}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo bash $0"
  exit 1
fi

if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
else
  echo "Cannot detect OS"
  exit 1
fi

install_nfs() {
  case "${ID:-}" in
    ubuntu|debian)
      apt-get update -y
      DEBIAN_FRONTEND=noninteractive apt-get install -y nfs-kernel-server
      ;;
    amzn|rhel|centos|fedora)
      if command -v dnf >/dev/null 2>&1; then
        dnf install -y nfs-utils
      else
        yum install -y nfs-utils
      fi
      systemctl enable --now rpcbind
      ;;
    *)
      echo "Unsupported OS: ${ID:-unknown}"
      exit 1
      ;;
  esac
}

install_nfs

mkdir -p "$EXPORT_PATH"
chmod 777 "$EXPORT_PATH"

EXPORTS_LINE="${EXPORT_PATH} ${NFS_CLIENT_CIDR}(rw,sync,no_subtree_check,no_root_squash)"
if [[ -f /etc/exports ]] && grep -qF "$EXPORT_PATH" /etc/exports; then
  sed -i "\|^${EXPORT_PATH} |d" /etc/exports
fi
echo "$EXPORTS_LINE" >> /etc/exports

exportfs -ra

if systemctl list-unit-files | grep -q '^nfs-server.service'; then
  systemctl enable --now nfs-server
  systemctl restart nfs-server
elif systemctl list-unit-files | grep -q '^nfs-kernel-server.service'; then
  systemctl enable --now nfs-kernel-server
  systemctl restart nfs-kernel-server
else
  echo "nfs-server unit not found"
  exit 1
fi

PRIVATE_IP="$(hostname -I | awk '{print $1}')"

echo
echo "NFS is up."
echo "  export : ${EXPORT_PATH}"
echo "  clients: ${NFS_CLIENT_CIDR}"
echo "  server : ${PRIVATE_IP}"
echo
echo "AWS security group inbound:"
echo "  TCP 2049 from your Kubernetes node SG or VPC CIDR"
echo "  TCP/UDP 111 from the same source (rpcbind)"
echo
echo "pvc.yml:"
echo "  nfs:"
echo "    path: ${EXPORT_PATH}"
echo "    server: ${PRIVATE_IP}"
echo
echo "On each Kubernetes node (if mounts fail):"
echo "  Ubuntu: sudo apt-get install -y nfs-common"
echo "  Amazon Linux: sudo dnf install -y nfs-utils"
echo
showmount -e localhost
