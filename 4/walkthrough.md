// ClusterIP
// Namespaces 
// How to reach internal services  -  deploying databases, kafka etc 
// manual certs in k8

??create a namspace 

k create namspace nameee

k get pods -n namespace-name

// make a ns the default 
k config set-context --current --namespace=backend-team


