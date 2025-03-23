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
