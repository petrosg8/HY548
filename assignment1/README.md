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

