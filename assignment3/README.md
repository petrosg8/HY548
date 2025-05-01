Exercise 1
(see ./hello-ingress.yaml)
    First we need to enable the ingress add on for minikube:
        $minikube addons enable ingress;
a.
    We need to add the following to the deployment manifest:

        resources:               
          limits:                
            cpu: "200m"          
            memory: "256Mi"
b.
    (see ./hello-hpa.yaml)



    First we need to enable the metrics-server for the HPA to poll 
    CPU usage:

        $minikube addons enable metrics-server;
    
    We then apply both of the manifests:

        $kubectl apply -f hello-ingress.yaml;

        $kubectl apply -f hello-hpa.yaml;

    We can watch the rollout:
        $kubectl get pods,svc,ing,hpa;
        NAME                         READY   STATUS    RESTARTS   AGE
        pod/hello-699d9475df-pr7qb   1/1     Running   0          9m26s

        NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
        service/hello        ClusterIP   10.111.85.31   <none>        8080/TCP   9m26s
        service/kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP    12m

        NAME                                      CLASS    HOSTS   ADDRESS        PORTS   AGE
        ingress.networking.k8s.io/hello-ingress   <none>   *       192.168.49.2   80      9m26s

        NAME                                            REFERENCE          TARGETS        MINPODS   MAXPODS   REPLICAS   AGE
        horizontalpodautoscaler.