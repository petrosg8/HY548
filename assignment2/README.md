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

        The Job is essentially the initialization of this workflow and the CronJob is the one that executes every night at
        2:15, refreshing the content.

        Data is not directly "communicated" between containers. Instead, config map volumes are created for the Job and the CronJob for the /download.sh script and there is a persistent volume claim for storing the downloaded content,which
        is mounted to each container respectively. Every time the CronJob is scheduled it downloads the content and stores it in this PVC which is also common/mounted to the Nginx pod in ./usr/share/nginx/html so that it serves the newly fetched content(index.html of csd.uoc.gr).

    c.



