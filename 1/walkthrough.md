kind create cluster --config cluster.yml --name local

// create pod of nginx

kubectl run nginx --image=niginx --port=80

// commands 
k get pods
k describe pods / k describe pod nginx 
k log nginx
//tail => k log nginx -f 
// watch => k get pods -w

//stop pods => k delete pod nginx 

not the right way to create pods 

the right way is manifest files 

Manifest
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

// apply manifest files 

k apply -f manifest.yml



