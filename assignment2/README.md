Assignment 2 - Kubernetes

1)
    a.
        see ./nginx-pod.yaml
        To install the manifest and start the Pod:

            $kubectl apply -f nginx-pod.yaml;
            
    b.
        To forward port 80 locally:

            $sudo kubectl port-forward nginx-pod 80:80;

        Without sudo:
            $kubectl port-forward nginx-pod 8080:80;
            `$curl -X GET localhost:8080
            <!DOCTYPE html>
            <html>
            <head>
            <title>Welcome to nginx!</title>
            <style>
            html { color-scheme: light dark; }
            body { width: 35em; margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif; }
            </style>
            </head>
            <body>
            <h1>Welcome to nginx!</h1>
            <p>If you see this page, the nginx web server is successfully installed and
            working. Further configuration is required.</p>

            <p>For online documentation and support please refer to
            <a href="http://nginx.org/">nginx.org</a>.<br/>
            Commercial support is available at
            <a href="http://nginx.com/">nginx.com</a>.</p>

            <p><em>Thank you for using nginx.</em></p>
            </body>
            </html>`
    c.
        To see the logs of the running container:

            $kubectl logs nginx-pod;
            
    d.  To open a shell session inside the running container:

            $kubectl exec -it nginx-pod -- /bin/sh;

        Go to directory where default index.html is located:

            $cd /usr/share/nginx/html;

        After editing the /usr/share/nginx/html/index.html, we can curl localhost to 
        verify changes are served:

            $$curl -X GET localhost:8080
            `<!DOCTYPE html>
            <html>
            <head>
            <title>Welcome to MY nginx!</title>
            <style>
            html { color-scheme: light dark; }
            body { width: 35em; margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif; }
            </style>
            </head>
            <body>
            <h1>Welcome to nginx!</h1>
            <p>If you see this page, the nginx web server is successfully installed and
            working. Further configuration is required.</p>

            <p>For online documentation and support please refer to
            <a href="http://nginx.org/">nginx.org</a>.<br/>
            Commercial support is available at
            <a href="http://nginx.com/">nginx.com</a>.</p>

            <p><em>Thank you for using nginx.</em></p>
            </body>
            </html>`
    e.  To copy the index.html file from the pod locally:

            $kubectl cp nginx-pod:/usr/share/nginx/html/index.html ./index.html;

        After editing the index.html file we can then copy it back into the pod:

            $$kubectl cp ./index.html nginx-pod:/usr/share/nginx/html/index.html;

        We can verify the changes curling localhost:
            $curl -X GET localhost:8080

            `html { color-scheme: light dark; }
            body { width: 35em; margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif; }
            </style>
            </head>
            <body>
            <h1>Welcome to YOUR nginx!</h1>
            <p>If you see this page, the nginx web server is successfully installed and
            working. Further configuration is required.</p>

            <p>For online documentation and support please refer to
            <a href="http://nginx.org/">nginx.org</a>.<br/>
            Commercial support is available at
            <a href="http://nginx.com/">nginx.com</a>.</p>

            <p><em>Thank you for using nginx.</em></p>
            </body>
            </html>`

    f.  To stop the pod and remove the manifest from Kubernetes we can:

            $kubectl delete -f nginx-pod.yaml;

        or

            $kubectl delete pod nginx-pod;
        
2)
    a.  see ./download_csduocgr_job.yaml
        The manifest contains a Job that uses 
        ubuntu:24.04 image to run the script
        ./download.sh which is defined as a config
        map volume and is mounted to ~/scripts
        inside the container.There is also a volume
        (emptyDir)for /data which is the container directory that stores the downloaded content.

        Before starting the job we first need to create
        the configMap for the script that will be ran:

            $kubectl create configmap download-script --from-file=download.sh;
        
        To apply the manifest and start the job:

            $kubectl apply -f download_csduocgr_job.yaml;
        
        We then can see completion status of the job using:

            $kubectl get job download-csduocgr-job;
            NAME                    STATUS     COMPLETIONS   DURATION   AGE
            download-csduocgr-job   Complete   1/1           13s        2m31s

        or,for more details:

            $kubectl describe job download-csduocgr-job;
        
        We can see also see the logs of the pod for more details:

            $kubectl logs download-csduocgr-job-rlq4w;
            `/usr/bin/wget
            --2025-03-23 19:37:25--  http://csd.uoc.gr/
            Resolving csd.uoc.gr (csd.uoc.gr)... 147.52.16.73
            Connecting to csd.uoc.gr (csd.uoc.gr)|147.52.16.73|:80... connected.
            HTTP request sent, awaiting response... 301 Moved Permanently
            Location: https://www.csd.uoc.gr/ [following]
            --2025-03-23 19:37:25--  https://www.csd.uoc.gr/
            Resolving www.csd.uoc.gr (www.csd.uoc.gr)... 147.52.16.73
            Connecting to www.csd.uoc.gr (www.csd.uoc.gr)|147.52.16.73|:443... connected.
            HTTP request sent, awaiting response... 200 
            Length: unspecified [text/html]
            Saving to: 'csd.uoc.gr/index.html'

                0K .......... .......... .......... .......... ..........  453K
                50K ....                                                   8.09M=0.1s

            2025-03-23 19:37:25 (490 KB/s) - 'csd.uoc.gr/index.html' saved [55441]

            FINISHED --2025-03-23 19:37:25--`

    b.  See ./download_and_serve.yaml. After applying the manifest:

            $kubectl apply -f download_and_serve.yaml;
            persistentvolumeclaim/web-content-pvc created
            job.batch/download-csduocgr-job created
            cronjob.batch/refresh-csduocgr-job created
            pod/nginx-pod created

        Now, when we port forward port 8080:80 we can see csd.uoc.gr/index.html served on localhost:8080.

        The Job is essentially the job that initially downloads the content of csd.uoc.gr and the CronJob is the one that executes every night at 2:15, refreshing the content.

        Data is not directly "communicated" between containers. Instead, config map volumes are created for the Job and the CronJob for the /download.sh script and there is a persistent volume claim for storing the downloaded content,which
        is mounted to each container respectively. Every time the CronJob is scheduled it downloads the content and stores it in this PVC which is also common/mounted to the Nginx pod in ./usr/share/nginx/html so that it serves the newly fetched content(index.html of csd.uoc.gr).

    c.  See ./download_and_serve_deployment.yaml.
        After applying the manifest of this deployment:
            $kubectl apply -f download_and_serve_deployment.yaml;
            deployment.apps/nginx-deployment created

            $kubectl get pods;
            NAME                                READY   STATUS      RESTARTS   AGE
            download-csduocgr-job-ck8xw         0/1     Completed   0          6m57s
            nginx-deployment-56489568fd-rglr7   0/1     Init:0/1    0          2s
            kubectl get pods;
            NAME                                READY   STATUS      RESTARTS   AGE
            download-csduocgr-job-ck8xw         0/1     Completed   0          7m2s
            nginx-deployment-56489568fd-rglr7   1/1     Running     0          7s

        We can now delete the Job and the nginx pod from the ./download_and_serve.yaml manifest since the init job is now done from the init container and served with the nginx container from the deployment.
        We can see that after the deployment is created there is a brief time window that the nginx pod has not started yet,
        only the init container. Only after the init container has completed downloading the content, the nginx container starts. We can also see that if we delete the nginx container that serves the content, another container is started,again.Curling the localhost before the init container has finished downloading the content, we can see that calls are not answered, meaning that the nginx container is not running yet.

    
3)  a.
        See ./Dockerfile -> petrosg8/nginx-download-site

        The site to be downloaded is defined when running the image using an enviroment variable:
            
            $docker run -d -p 8080:80 -e SITE_URL=http://csd.uoc.gr petrosg8/nginx-download-site:latest;

        By default this enviroment variable is set to http://example.com.

    b.
        See ./ex3_deployment.yaml
        The deployment contains the 2 pods that serve the csd.uoc.gr. The site to be served is defined in the yaml as
        an enviroment variable in the deployment containers. The service is a LoadBalancer service,we then can use :

            $minikube tunnel;

        to access the service from localhost.


        After applying the manifest:
            
            $kubectl apply -f ex3_deployment.yaml;
            deployment.apps/nginx-download-site-deployment created
            service/nginx-download-site-service created 

            $kubectl describe svc nginx-download-site-service
            Name:                     nginx-download-site-service
            Namespace:                default
            Labels:                   <none>
            Annotations:              <none>
            Selector:                 app=nginx-download-site
            Type:                     LoadBalancer
            IP Family Policy:         SingleStack
            IP Families:              IPv4
            IP:                       10.98.141.204
            IPs:                      10.98.141.204
            LoadBalancer Ingress:     127.0.0.1
            Port:                     <unset>  8080/TCP
            TargetPort:               80/TCP
            NodePort:                 <unset>  30808/TCP
            Endpoints:                10.244.0.79:80,10.244.0.84:80
            Session Affinity:         None
            External Traffic Policy:  Cluster
            Events:                   <none>

        We then can use the following command to access the service from localhost:
            
            $minikube tunnel;
        
        Now we can access the service from localhost and see the csd.uoc.gr site is served 
        We can see that there are 2 pods running for this deployment:

            $kubectl get pods -l app
            NAME                                              READY   STATUS    RESTARTS        AGE
            nginx-download-site-deployment-55dd99ff58-8swx6   1/1     Running   6 (5m12s ago)   19m
            nginx-download-site-deployment-55dd99ff58-w4npl   1/1     Running   6 (5m17s ago)   19m

        
    c.
        See ./mathuocgr_deployment.yaml
        The manifest contains the same deployment/LoadBalancer pair for 2 pods serving the math.uoc.gr site.

        We first need to enable the ingress minikube addon

            $minikube addons enable ingress;

        Applying the manifest:

            $kubectl apply -f mathuocgr_deployment.yaml
            deployment.apps/nginx-download-math-deployment created
            service/nginx-download-math-service created
            ingress.networking.k8s.io/uoc-ingress created

        With the ingress now created, we can see that calls to http://localhost/math are answered with math.uoc.gr content
        and calls to http://localhost/csd are answered with csd.uoc.gr content from each service respectively.

        Curling without a /path now is answered with 404:

            $curl localhost;
            <html>
            <head><title>404 Not Found</title></head>
            <body>
            <center><h1>404 Not Found</h1></center>
            <hr><center>nginx</center>
            </body>
            </html>
        
            $kubectl describe ingress uoc-ingress
            Name:             uoc-ingress
            Labels:           <none>
            Namespace:        default
            Address:          192.168.49.2
            Ingress Class:    nginx
            Default backend:  <default>
            Rules:
            Host        Path  Backends
            ----        ----  --------
            *           
                        /csd    nginx-download-site-service:8080 (10.244.0.79:80,10.244.0.84:80)
                        /math   nginx-download-math-service:8080 (10.244.0.85:80,10.244.0.86:80)
            Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
            Events:
            Type    Reason  Age                    From                      Message
            ----    ------  ----                   ----                      -------
            Normal  Sync    9m33s (x2 over 9m54s)  nginx-ingress-controller  Scheduled for sync

        