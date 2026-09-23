kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

//access argocd ui 

kubectl port-forward svc/argocd-server -n argocd 8080:443

//get argo password

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"