

SERVICES AND NAMESPACES 

// ran deployments . now we have to expose them 

// create cluster 

kind create cluster --config kind.yml -n local

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker

SERVICES
    - Nodeport - external access 
    - CLusterIP - internal access 
    - Load BAlancer - External access 

services exposes the pods . 

//service.yml

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80 //final application port on the container
      nodePort: 30007  # This port can be any valid port within the NodePort range
  type: NodePort

//kind.yml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30007 // port of the master node 
    hostPort: 30007 // port of mac    /./ odone so that when we add nodeport 3000 port of mac points to 3000 port of node 
- role: worker
- role: worker

kind create cluster --config kind.yml
Re apply the deployment and the service
Visit localhost:3000


// issue with nodeport

lets sayv 3 nodes . cp , wk1 , wk 2 

users will be able to hit aws.alen.wk1:8080
                          aws.alen.wk2:8080

not ideal , users can ddos  no lb and stuff

// Created another pod of httpd but ke[pt label as NGINX 

apiVersion: v1
kind: Pod
metadata:
  name: httpd
  labels:
    app: nginx
spec: 
  containers: 
  - name: httpd
    image: httpd
    ports:
    - containerPort: 80
    - containerPort: 443

THIS RESULTS IN NODEPORT LOADBALANCING THE REQ TO BOTH HTTPD AND NGINX WHEN WE HIT port 30007 
