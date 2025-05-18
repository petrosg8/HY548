## Assignment 4



## 1

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
