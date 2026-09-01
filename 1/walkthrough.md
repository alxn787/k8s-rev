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

