#!/usr/bin/env sh

set -e

command -v minikube 2>&1 || {
    echo "Could not find minikube on machine...";
    exit 1
}

command -v kubectl 2>&1 || {
    echo "Could not find kubectl on machine...";
    exit 2
}

minikube delete
kubectl config delete-context minikube