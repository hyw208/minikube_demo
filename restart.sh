
kubectl delete deployment demoapp
kubectl delete pod demoapp
kubectl delete service demoapp

kubectl create -f demoapp-deployment.yaml

kubectl get deployment demoapp
kubectl get pod demoapp
kubectl get service demoapp

