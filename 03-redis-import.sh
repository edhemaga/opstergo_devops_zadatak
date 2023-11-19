#!/usr/bin/env bash

#Use pwd in order not to hard code the path
kubectl cp $(pwd)/import/redis/data.txt master-0:data.txt

kubectl exec master-0 -- /bin/bash -c 'while IFS= read -r line; do redis-cli $line; done < $(pwd)/data.txt'
