# minikube_demo

# demo debug python flask with rpdb in minikube

0. assume you have docker and minikube installed started correctly  
    >eval $(minikube docker-env)

    use minikube internal docker daemon to build/use images locally
    
1. check out: 
    >git clone https://github.com/hyw208/minikube_demo.git

2. change the path in demoapp-deployment.yaml, replace path "/Users/hyw208/Documents/Code/python/minikube_demo/demoapp" to match yours. Note, you have to have source code e.g. demo.py in the path you specified, otherwise the container will exit
    
3. build docker image
    >cd minikube_demo && docker build -t demoapp:demo .

4. add exe permission
    >chmod +x restart.sh
    
5. deploy
    >./restart.sh
    
6. get acutal ports, 30325 to access flask, 30547 for debug with rpdb
    >kubectl get service demoapp
    
    e.g. 5000:30325/TCP,4444:30547/TCP

7. test flask app, **IT WILL BLOCK WAITING FOR DEBUGGER**
    >curl $(minikube ip):30325
    
8. bring up another console and use pdb to debug
    >nc $(minikube ip) 30547

9. you can change the code in demo.py under your path e.g. /Users/hyw208/Documents/Code/python/minikube_demo/demoapp/demo.py and changes should reflect asap

10. you can use kubectl to copy files/directories btw your host and remote pod, 
    >kubectl cp demoapp-57fb996db7-vz9km:/demoapp/demo.py ./demo.py
    
    'demoapp-57fb996db7-vz9km' is the pod, you can use kubectl get pods to find; 
    '/demoapp/demo.py' is the pod's source code; 
    './demo.py' just copy and put in current directory; 

    or just use docker cp, where '155286a1a608' is the container id you can get with 'docker ps' cmd
    >docker cp 155286a1a608:/demoapp ./demoapp

# demo debug python flask with eclipse + pydev in minikube

0. assume you have eclipse + pydev plugin and pip installed pydevd on host computer. if docker container is built with conda, you can export env into a requirements.txt or environment.yaml and create same conda env and configure pydev interpreter as prep step.

1. for IDE debug, you can use eclipse with pydev instead of rpdb, change the code in demo.py to the following:
    >import pydevd #import rpdb  
	
    >pydevd.settrace("192.168.1.156", port=5678) #rpdb.set_trace('0.0.0.0')
    
    ps. "192.168.1.156" is the host ip
    
2. change requirements.txt, replace **rpdb** with **pydevd**

3. build docker image again
    >docker build -t demoapp:demo .

4. deploy
    >./restart.sh

5. get acutal ports, 30325 to access flask, 30547 for debug with rpdb
    >kubectl get service demoapp
    
    e.g. 5000:30325/TCP,5678:30547/TCP

6. open debug perspective in eclipse, and start PyDev server (it waits for remote pydevd to connect to back to IDE)

7. invoke flask app, it will cause pydevd to connect to eclipse via the pre-configured ip & port, e.g. 192.168.1.156 & 5678
    >curl $(minikube ip):30325
    
8. your PyDev server in eclipse will ask you to select the path to demo.py, you can ignore or provide your local copy and start debugging. If you ignore, you will be stepping with temp files downloaded from container


# say you are given the image and don't have source code locally

1. keep the docker image you previously built, demoapp-deployment.yaml, and the restart.sh and delete the rest

2. delete/comment out line 24~30 in demoapp-deployment.yaml, removing the volume mapping portion

3. re-deploy 
    >restart.sh

4. get acutal ports, 30325 to access flask, 30547 for debug with rpdb
    >kubectl get service demoapp
    
    e.g. 5000:30325/TCP,5678:30547/TCP

5. open debug perspective in eclipse, and start PyDev server (it waits for remote pydevd to connect to back to IDE)

6. invoke flask app, it will cause pydevd to connect to eclipse via the pre-configured ip & port, e.g. 192.168.1.156 & 5678
    >curl $(minikube ip):30325

7. your PyDev server in eclipse will ask you to select the path to demo.py and you can only ignore since you have no source code locally but should still be able to debug
