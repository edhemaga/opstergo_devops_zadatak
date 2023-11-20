#!/usr/bin/env bash
kubectl exec master-0 -- /bin/bash -c 'redis-cli flushall'
