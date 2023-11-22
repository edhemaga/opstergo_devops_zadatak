#!/usr/bin/env bash

# Get the name of the first pod, since in our case the first pod will always be the master, we can only take the first result
pod=$(kubectl get pods -o custom-columns=NAME:.metadata.name --no-headers -n redis | head -n 1)

#This needs to be reworked
while ! [ "${pod}" ]; do
    echo "Pod is ${pod}"
    pod=$(kubectl get pods -o custom-columns=NAME:.metadata.name --no-headers -n redis | head -n 1)
    sleep 10
done

if [[ -z "$pod" ]]; then
    echo "Pod could not be found; Assinging hardcoded value!"
    $pod = 'redis-0'
fi

# Use pwd in order not to hard code the path
kubectl -n redis cp $(pwd)/import/redis/data.txt $pod:data.txt 

# Read by line, and remove unecessary \/ and ""
kubectl -n redis exec $pod -- /bin/bash -c 'while IFS= read -r ${line//\\/}; do redis-cli $line; done < $(pwd)/data.txt'

# Assign replicas
# ip-master=$(kubectl get ${pod} nginx --template '{{.status.podIP}}')
# kubectl exec -it redis-1 -- /bin/bash -c redis-cli replicaof $ip-master
# This is the idea of assigning replicas to master, this needs to be reworked further