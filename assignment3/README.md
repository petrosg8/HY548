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
        horizontalpodautoscaler.autoscaling/hello-hpa   Deployment/hello   cpu: 0%/80%   1         8         1          9m22s
    
        After using $minikube tunnel:
        We can use a http benchmark tool to test the Deployment's scaling:
            $hey -z 10m -c 100 http://127.0.0.1/hello

                Summary:
                Total:	600.8806 secs
                Slowest:	5.9037 secs
                Fastest:	0.0054 secs
                Average:	0.8142 secs
                Requests/sec:	122.7182
                
                Total data:	58620570 bytes
                Size/request:	794 bytes

                Response time histogram:
                0.005 [1]	|
                0.595 [44978]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
                1.185 [8287]	|■■■■■■■
                1.775 [8830]	|■■■■■■■■
                2.365 [6346]	|■■■■■■
                2.955 [2587]	|■■
                3.544 [958]	|■
                4.134 [585]	|■
                4.724 [607]	|■
                5.314 [470]	|
                5.904 [90]	|


                Latency distribution:
                10% in 0.0520 secs
                25% in 0.1241 secs
                50% in 0.3966 secs
                75% in 1.3049 secs
                90% in 2.1006 secs
                95% in 2.6942 secs
                99% in 4.4039 secs

                Details (average, fastest, slowest):
                DNS+dialup:	0.0000 secs, 0.0054 secs, 5.9037 secs
                DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0000 secs
                req write:	0.0000 secs, 0.0000 secs, 0.0088 secs
                resp wait:	0.6643 secs, 0.0013 secs, 4.9121 secs
                resp read:	0.0001 secs, 0.0000 secs, 0.0131 secs

                Status code distribution:
                [200]	73736 responses
                [502]	3 responses



        And then we can monitor the scaling:
        $kubectl get hpa hello-hpa -w
        NAME        REFERENCE          TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
        hello-hpa   Deployment/hello   cpu: <unknown>/80%   1         8         0          1s
        hello-hpa   Deployment/hello   cpu: 5%/80%          1         8         1          15s
        hello-hpa   Deployment/hello   cpu: 8%/80%          1         8         1          60s
        hello-hpa   Deployment/hello   cpu: 99%/80%         1         8         1          2m
        hello-hpa   Deployment/hello   cpu: 99%/80%         1         8         2          2m15s
        hello-hpa   Deployment/hello   cpu: 86%/80%         1         8         2          3m
        hello-hpa   Deployment/hello   cpu: 88%/80%         1         8         2          4m
        hello-hpa   Deployment/hello   cpu: 88%/80%         1         8         3          4m15s
        hello-hpa   Deployment/hello   cpu: 95%/80%         1         8         3          5m
        hello-hpa   Deployment/hello   cpu: 99%/80%         1         8         3          6m
        hello-hpa   Deployment/hello   cpu: 99%/80%         1         8         4          6m15s
        hello-hpa   Deployment/hello   cpu: 97%/80%         1         8         4          7m1s
        hello-hpa   Deployment/hello   cpu: 96%/80%         1         8         4          8m1s
        hello-hpa   Deployment/hello   cpu: 96%/80%         1         8         5          8m16s
        hello-hpa   Deployment/hello   cpu: 97%/80%         1         8         5          9m1s
        hello-hpa   Deployment/hello   cpu: 96%/80%         1         8         5          10m
        hello-hpa   Deployment/hello   cpu: 96%/80%         1         8         6          10m
        hello-hpa   Deployment/hello   cpu: 89%/80%         1         8         6          11m
        hello-hpa   Deployment/hello   cpu: 0%/80%          1         8         6          12m
        hello-hpa   Deployment/hello   cpu: 1%/80%          1         8         6          13m
        hello-hpa   Deployment/hello   cpu: 0%/80%          1         8         6          14m
        hello-hpa   Deployment/hello   cpu: 1%/80%          1         8         6          15m
        hello-hpa   Deployment/hello   cpu: 0%/80%          1         8         6          16m
        hello-hpa   Deployment/hello   cpu: 0%/80%          1         8         6          16m
        hello-hpa   Deployment/hello   cpu: 0%/80%          1         8         1          17m

        We can also view the Deployment's scaling through a monitoring dashboard(minikube dashboard in this case):
        ### HPA Scaling 
            ![HPA Scaling](/assignment3/dashboard_screenshot.png)


        
