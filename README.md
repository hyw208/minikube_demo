# minikube_demo
demo python flask debug in minikube

1. check out: 
    >>git clone https://github.com/hyw208/minikube_demo.git
    
2. build docker image
    >>cd minikube_demo && docker build -t demoapp:demo .

3. change the path in demoapp-deployment.yaml, replace path "/Users/hyw2082004/Documents/Code/python/minikube_demo/demoapp" to match yours

4. add exe permission
    >chmod +x restart.sh
    
5. deploy
    >./restart.sh
    
6. get acutal ports, 30325 to access flask, 4444 for debug with rpdb
    >kubectl get service demoapp
    e.g. 5000:30325/TCP,4444:30547/TCP

7. test flask app, IT WILL BLOCK WAITING FOR DEBUGGER
    > curl $(minikube ip):30325
    
8. bring up another console
    > nc $(minikube ip) 30547

9. you can change the code in demo.py under your path e.g. /Users/hyw2082004/Documents/Code/python/minikube_demo/demoapp/demo.py and changes should reflect asap

