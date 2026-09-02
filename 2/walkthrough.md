//Replicasets 

decides on how many replicas iof a pod needs to set up ..

User => Deployment => Replicasets => pods

even if pod crashes , it restarts (even if deleted)

apiVersion: apps/v1  
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector: //  how does rs know which pod it is . here matching the label with appname
    matchLabels:
      app: nginx
  template:  => what does one pod look like 
    metadata:
      labels: // just kv . appnginx dev alen anything ..  
        app: nginx
    spec:
      containers:
      - name: nginx // this isjust the prefix 
        image: nginx:latest
        ports:
        - containerPort: 80
      - name: mongo 
        image: mongo:latest
        ports:
        - containerPort: 21707


//DEPLOYMENTS

manages replicasets does rolling upgrades, auto rollbacks etc

deployment => replicasets => pods

