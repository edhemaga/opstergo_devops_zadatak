#!/usr/bin/env bash

set -e

# variables
source ./_init_variables.sh

# check minikube
command -v minikube 2>&1 || {
    echo "Could not find minikube on machine...";
    exit 100
}

# check kubectl
command -v kubectl 2>&1 || {
    echo "Could not find kubectl on machine...";
    exit 101
}

case "$(uname -s)" in
   # if running on MacOS then use hyperkit virtualizator
   Darwin*)
     minikube config set vm-driver hyperkit;;
   *)
     minikube config set vm-driver virtualbox;;
esac

( minikube status ) || minikube start --kubernetes-version ${KUBERNETES_VERSION} --nodes 2


# enable metrics server
minikube addons enable metrics-server

MINIKUBE_IP=`minikube ip`


echo
echo "Cool! MiniKube is up on ${MINIKUBE_IP} address."
