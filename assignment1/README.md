# Assignment 1 - Docker Basics

1)
    a.Download the images tagged 1.27.4 and 1.27.4-alpine locally:

        $docker pull nginx:1.27.4
        $docker pull nginx:1.27.4-alpine

    b.Compare the sizes of the two images.

        executing: $docker images
            REPOSITORY   TAG             IMAGE ID       CREATED       SIZE
            nginx        1.27.4          91734281c0eb   2 weeks ago   280MB
            nginx        1.27.4-alpine   4ff102c5d78d   2 weeks ago   75.4MB

    c.Start nginx:1.27.4 in the background, with the appropriate network settings to forward port 80 locally at port 8000   and use a browser (or curl or wget) to see that calls are answered. What is the answer?
        
        $docker run -d -p 8000:80 nginx:1.27.4

        $curl http://public_ip:8000/
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
            </html>

        The calls are answered.The response we get is the default nginx welcome page.
    
    d.Confirm that the container is running in Docker
    
        $docker ps
            CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                
            cc8cf8e69667   nginx:1.27.4   "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   0.0.0.0:8000->80/tcp 
            NAMES
            compassionate_kapitsa  

        We can see the container we started, forwarding port 8000 to local tcp port 80.

    e.Get the logs of the running container

        $docker logs #container_id

            /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
            /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
            /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
            10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
            10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
            /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
            /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
            /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
            /docker-entrypoint.sh: Configuration complete; ready for start up
            2025/02/20 15:32:28 [notice] 1#1: using the "epoll" event method
            2025/02/20 15:32:28 [notice] 1#1: nginx/1.27.4
            2025/02/20 15:32:28 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14) 
            2025/02/20 15:32:28 [notice] 1#1: OS: Linux 6.12.5-linuxkit
            2025/02/20 15:32:28 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
            2025/02/20 15:32:28 [notice] 1#1: start worker processes
            2025/02/20 15:32:28 [notice] 1#1: start worker process 29
            2025/02/20 15:32:28 [notice] 1#1: start worker process 30
            2025/02/20 15:32:28 [notice] 1#1: start worker process 31
            2025/02/20 15:32:28 [notice] 1#1: start worker process 32
            2025/02/20 15:32:28 [notice] 1#1: start worker process 33
            2025/02/20 15:32:28 [notice] 1#1: start worker process 34
            2025/02/20 15:32:28 [notice] 1#1: start worker process 35
            2025/02/20 15:32:28 [notice] 1#1: start worker process 36
            192.168.65.1 - - [20/Feb/2025:15:35:02 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.6.0" "-"

        We can see the log of the curl command issued before.
    
    f.Stop the running container
    
        $docker stop #container_id

        Executing $docker ps; now, does not show the container as running.

    g.Start the stopped container
    
        $docker start #container_id
        
        Executing $docker ps; now, shows the container as running.

    h.Stop the container and remove it from Docker.

        $docker rm #container_id

        Executing $docker logs #container_id; now :
            $Error response from daemon: No such container: #container_id
        Verifying that the container has been removed from Docker.



2)

a.
    Running the Nginx container again, we can open a shell session on the container using:
        $docker exec -it #container_id /bin/bash
    We then locate the directory of the default index.html Nginx page(/usr/share/nginx/html/index.html).
    We then modify the index.html file to our desired page.

    Confirming the updates using :

        $curl http://public_ip:8000/
    
    We now get the response confirming our updates:

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
            <h1>Welcome to MY nginx!</h1>
            <p>If you see this page, the nginx web server is successfully installed and
            working. Further configuration is required.</p>

            <p>For online documentation and support please refer to
            <a href="http://nginx.org/">nginx.org</a>.<br/>
            Commercial support is available at
            <a href="http://nginx.com/">nginx.com</a>.</p>

            <p><em>Thank you for using nginx.</em></p>
            </body>
            </html>

b.
    From your computer's terminal (outside the container) download the default page locally and upload another one in its place. Validate the change.

        
        $docker cp #container_id:/usr/share/nginx/html/index.html ./index.html

    Modifying the index.html file locally,and the copying it to the running container:

        $docker cp index.html #container_id:/usr/share/nginx/html/index.html

    We can validate the changes:
        $curl http://public_ip:8000/
            <!DOCTYPE html>
            <html>
            <head>
            <title>Welcome to YOUR nginx!</title>
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
            <a href="http://nginx.com/">nginx.com</a>.</p>

            <p><em>Thank you for using nginx.</em></p>
            </body>
            </html>    

c.
    Close the container, delete it and start another instance. Do you see the changes? Why?
        
        $docker stop #container_id
        $docker rm #container_id
        $docker run -d -p 8000:80 nginx:1.27.4
        $curl http://public_ip:8000/
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
            </html>

        We can now see that after stopping,removing and re-running the container, we get the deafult Nginx index.html 
        as the response. That happens because when you start a new container, it pulls the default index.html from the original Nginx image, not the modified one.
d.  
    Start an Nginx container to serve the page from the local folder instead of the default page. Validate that the correct content is served.

        After creating a new directory containing the index.html nginx file, we start the container 
        with the volume attached to it.

            $docker run -d -p 8000:80 -v /Volumes/custom-nginx:/usr/share/nginx/html nginx:1.27.4;
            $curl localhost:8000;
                <h1>Welcome to MY Custom Nginx Page!</h1>

        If we stop and re-start the container we still get the same response. That is because we have attached a volume 
        to the container, therefore the custom directory is persistent.        


3.
    An example of a very simple Django application is available in the course's repository on GitHub (https://github.com/chazapis/hy548/django). The code is based on the tutorial included in the documentation (https://docs.djangoproject.com/en/5.1/intro/tutorial01/). You are encouraged to follow the tutorial to get acquainted with the commands necessary for the following steps. Write down the commands needed to start a Python container, get a shell environment into it, copy the files in, install the necessary software (listed in requirements.txt), initialize the application, start it, validate that it works.

        It is important that we map local port 8000 to the containers' port 8000:
        
            $docker run -p 8000:8000 -it --name django-container python:3.11 /bin/bash;
        
        We need to create the directories for the application in the container:
            
            $mkdir -p /app/mysite;


        In a different local shell tab, we run the commands to copy the files to the container:

            $docker cp ./manage.py django-container:/app/;
            $docker cp ./requirements.txt django-container:/app/;
            $docker cp ./mysite/settings.py django-container:/app/mysite/;
            $docker cp ./mysite/urls.py django-container:/app/mysite/;
            $docker cp ./mysite/asgi.py django-container:/app/mysite/;
            $docker cp ./mysite/wsgi.py django-container:/app/mysite/;

        After copying the files, we need to create the directory for the database, required by the django application
        and also change the permissions for the directory:
            
            ./app: $mkdir -p db;
            ./app: $chmod -R 777 db;

        We then update pip and install the requirements for the application, listed in requirements.txt:

            $pip install --upgrade pip;
            $pip install -r requirements.txt;


        We then can initialize the application:

            $python manage.py migrate;

        And finally run the server on localhost:8000 using:

            $python manage.py runserver 0.0.0.0:8000;

        Visiting localhost:8000 on a browser, we can see the default django page.
        We can also see the logs of the server outputed on the container shell.

4.

a.  (see Dockerfile: /assignment1/Dockerfile)

    An entrypoint shell script was created (see: /assignment1/django-entrypoint.sh). When the container is started, 
    the scripts executes, initializing the database of the app and then running the server.

    Defined a default homepage on /mysite/urls.py.

    Changed the allowed hosts to "['localhost', '127.0.0.1']" in /mysite/settings.py.

    Changed DJANGO_DEBUG=0 to be the default, configuration when running the container without 
    $-e DJANGO_DEBUG=1; on the commandline

        
b.  We can compare our local images and their sizes using:
        
        $docker images | grep python
        $docker images | grep my-django-app

            python          3.13.2          08471c63c5fd   3 weeks ago      1.47GB
            my-django-app   latest          4931c9179b2d   14 minutes ago   1.55GB
    
    The custom image is ~80MB larger than the base python 3.13.2 image.
    Several things contribute to the increase in size.We installed vim-tiny, which adds extra binaries and libraries, although this increases the image size slightly, because it is already a minimal version of Vim.
    Django and its dependencies contribute additional files, including Python packages and libraries.
    We also copied the entire Django project.

    Several steps were taken to keep the image as small as possible. Used --no-cache-dir for pip install which
    prevents storing package cache, reducing image size. We also removed APT cache after installing packages.


c.  
    To tag the image with "latest" tag:

        $docker tag my-django-app petrosg8/my-django-app:latest;

    To push the image to Dockerhub:
        $docker push petrosg8/my-django-app:latest;    

d.
    To run the image in debug mode:

        $docker run -d -p 8000:8000 -v /Volumes/django-app-db:/app/db -e DJANGO_DEBUG=1 petrosg8/my-django-app;

    To verify that the app is running on debug mode:
        
        $curl localhost:8000/error | grep DEBUG;
            % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                            Dload  Upload   Total   Spent    Left  Speed
            100  2333  100  2333    0     0   257k      0 --:--:-- --:--:-- --:--:--  284k
                You’re seeing this error because you have <code>DEBUG = True</code> in

    And to run it in production mode:

        $docker run -d -p 8000:8000 -v /Volumes/django-app-db:/app/db -e petrosg8/my-django-app;

        or

        $docker run -d -p 8000:8000 -v /Volumes/django-app-db:/app/db -e DJANGO_DEBUG=0 petrosg8/my-django-app;

    To verify that the app is running with debug mode off :
        
        $curl localhost:8000
        <h1>Welcome to My Django App!</h1>% 

        and 
    
        $curl localhost:8000/error;
            <!doctype html>
            <html lang="en">
            <head>
            <title>Not Found</title>
            </head>
            <body>
            <h1>Not Found</h1><p>The requested resource was not found on this server.</p>
            </body>
            </html>
        
        Confirming that we cant request /error when ran in production mode.