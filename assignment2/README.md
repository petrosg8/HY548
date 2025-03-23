Assignment 2 - Kubernetes
1)
a. Deploy the Nginx Pod
Manifest file: ./nginx-pod.yaml

Install the manifest and start the Pod:

bash
Copy
kubectl apply -f nginx-pod.yaml
b. Port Forwarding
With sudo (for forwarding port 80 locally):

bash
Copy
sudo kubectl port-forward nginx-pod 80:80
Without sudo (using an alternate local port):

bash
Copy
kubectl port-forward nginx-pod 8080:80
Test with curl:

bash
Copy
curl -X GET localhost:8080
Expected HTML output:

html
Copy
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
     <a href="http://nginx.com/">nginx.com</a>.
  </p>
  <p><em>Thank you for using nginx.</em></p>
</body>
</html>
c. Viewing Logs
To see the logs of the running container:

bash
Copy
kubectl logs nginx-pod
d. Executing Commands Inside the Pod
Open a shell session inside the running container:

bash
Copy
kubectl exec -it nginx-pod -- /bin/sh
Navigate to the directory containing the default index.html:

bash
Copy
cd /usr/share/nginx/html
After editing /usr/share/nginx/html/index.html, verify the changes by curling localhost:

bash
Copy
curl -X GET localhost:8080
Expected HTML output (example after editing):

html
Copy
<!DOCTYPE html>
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
     <a href="http://nginx.com/">nginx.com</a>.
  </p>
  <p><em>Thank you for using nginx.</em></p>
</body>
</html>
e. Copying Files to/from the Pod
Copy index.html from the pod to your local machine:

bash
Copy
kubectl cp nginx-pod:/usr/share/nginx/html/index.html ./index.html
After editing the local index.html, copy it back into the pod:

bash
Copy
kubectl cp ./index.html nginx-pod:/usr/share/nginx/html/index.html
Verify the changes by curling localhost:

bash
Copy
curl -X GET localhost:8080
Expected HTML output (example after editing):

html
Copy
<html>
<head>
  <style>
    html { color-scheme: light dark; }
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
     <a href="http://nginx.com/">nginx.com</a>.
  </p>
  <p><em>Thank you for using nginx.</em></p>
</body>
</html>
f. Stopping and Cleaning Up
To stop the pod and remove the manifest from Kubernetes:

bash
Copy
kubectl delete -f nginx-pod.yaml
Alternatively, delete the pod directly:

bash
Copy
kubectl delete pod nginx-pod
2)






