## Assignment 4



## Exercise 1

    see ./assignment4/fruit-crd.yaml && apple-fruit.yaml


a)  To install the custom resource:

        $kubectl apply -f fruit-crd.yaml;

b)  To create the "apple" instance:

        $kubectl apply -f apple-fruit.yaml;

c)  To return the new instance in YAML format:

        $kubectl get fruit apple -o yaml;

        apiVersion: hy548.csd.uoc.gr/v1
        kind: Fruit
        metadata:
        annotations:
            kubectl.kubernetes.io/last-applied-configuration: |
            {"apiVersion":"hy548.csd.uoc.gr/v1","kind":"Fruit","metadata":{"annotations":{},"name":"apple","namespace":"default"},"spec":{"count":3,"grams":980,"origin":"Krousonas"}}
        creationTimestamp: "2025-05-13T15:18:58Z"
        generation: 1
        name: apple
        namespace: default
        resourceVersion: "484"
        uid: c42550e2-6bcf-42b8-a818-0c7af098fb94
        spec:
        count: 3
        grams: 980
        origin: Krousonas

d)  To return a list of all available instances:

        $kubectl get fruits;
        NAME    AGE
        apple   57s


## Exercise 2
    
a)  see ./assignment4/ex2/Dockerfile -> petrosg8/greeting-controller:v1

b)  see ./assignment4/ex2/greeting-controller.yaml 


    To verify that the deployment works correctly:

        $kubectl apply -f greeting-crd.yaml;

        $kubectl apply -f greeting-controller.yaml;


        $kubectl get pods -n greeting-system;        
        NAME                                   READY   STATUS    RESTARTS   AGE
        greeting-controller-6b7549cb55-5qrx2   1/1     Running   0          94s


        $kubectl logs -f deploy/greeting-controller -n greeting-system;
        2025-05-13 17:12:12 INFO check_and_apply: New loop
        2025-05-13 17:12:12 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:12:13 INFO check_and_apply: Working in namespace: greeting-system
        2025-05-13 17:12:13 INFO check_and_apply: Working in namespace: kube-node-lease
        2025-05-13 17:12:13 INFO check_and_apply: Working in namespace: kube-public
        2025-05-13 17:12:13 INFO check_and_apply: Working in namespace: kube-system
        2025-05-13 17:12:16 INFO check_and_apply: New loop
        2025-05-13 17:12:16 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:12:16 INFO check_and_apply: Working in namespace: greeting-system
        2025-05-13 17:12:16 INFO check_and_apply: Working in namespace: kube-node-lease
        2025-05-13 17:12:16 INFO check_and_apply: Working in namespace: kube-public
        2025-05-13 17:12:16 INFO check_and_apply: Working in namespace: kube-system
        2025-05-13 17:12:19 INFO check_and_apply: New loop

        This verifies that the reconcilation loop is working. We need to create a CRD 
        so that the controller picks it up.

        Applying ~kalimera.yaml:

            kubectl apply -f kalimera.yaml;
            greeting.hy548.csd.uoc.gr/kalimera created


        2025-05-13 17:57:00 INFO check_and_apply: New loop
        2025-05-13 17:57:00 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:03 INFO check_and_apply: New loop
        2025-05-13 17:57:03 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:06 INFO check_and_apply: New loop
        2025-05-13 17:57:06 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:09 INFO check_and_apply: New loop
        2025-05-13 17:57:09 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:09 INFO check_and_apply: Found crd: kalimera (message: kalimera, replicas: 2)
        2025-05-13 17:57:09 INFO create_service: Writing rendered template in /src/tmp/kalimera.yaml and creating service...
        service/kalimera created
        deployment.apps/kalimera created
        2025-05-13 17:57:12 INFO check_and_apply: New loop
        2025-05-13 17:57:12 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:13 INFO check_and_apply: Found crd: kalimera (message: kalimera, replicas: 2)
        2025-05-13 17:57:13 INFO check_and_apply: Service already created. Skipping...
        2025-05-13 17:57:16 INFO check_and_apply: New loop
        2025-05-13 17:57:16 INFO check_and_apply: Working in namespace: default
        2025-05-13 17:57:16 INFO check_and_apply: Found crd: kalimera (message: kalimera, replicas: 2)
        2025-05-13 17:57:16 INFO check_and_apply: Service already created. Skipping...


        Verifying that the service was created:

            $curl localhost:8080;
            <!DOCTYPE html>
            <html>
            <head>
                <title>Hello Kubernetes!</title>
                <link rel="stylesheet" type="text/css" href="/css/main.css">
                <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Ubuntu:300" >
            </head>
            <body>

            <div class="main">
                <img src="/images/kubernetes.png"/>
                <div class="content">
                <div id="message">
            kalimera
            </div>
            <div id="info">
            <table>
                <tr>
                <th>namespace:</th>
                <td>-</td>
                </tr>
                <tr>
                <th>pod:</th>
                <td>kalimera-68596d6769-wqm2n</td>
                </tr>
                <tr>
                <th>node:</th>
                <td>- (Linux 6.12.5-linuxkit)</td>
                </tr>
            </table>
            </div>
            <div id="footer">
            paulbouwer/hello-kubernetes:1.10.1 (linux/amd64)
            </div>
                </div>
            </div>

            </body>
            </html>%         

        As soon as we delete greeting kalimera, the controller picks up the deletion 
        and removes the corresponding service:
        
            $kubectl -n default delete greeting kalimera;            

            2025-05-13 18:03:06 INFO check_and_apply: New loop
            2025-05-13 18:03:06 INFO check_and_apply: Working in namespace: default
            2025-05-13 18:03:06 INFO delete_service: Removing service /src/tmp/kalimera.yaml and associated rendered template...
            service "kalimera" deleted
            deployment.apps "kalimera" deleted