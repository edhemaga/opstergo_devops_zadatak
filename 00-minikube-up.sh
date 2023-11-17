#!/usr/bin/env bash

set -e

# variables
source ./_init_variables.sh

# check minikube
#Check if minikube exists, 2>&1 does not return error as such but transfers it to standard output
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
    #Docker needs to be running, therefore the script should start docker deamon
    open -a Docker
    #Since Hyperkit is not supported on M1 an adjustment was made
    minikube config set driver docker;;
    #minikube config set vm-driver hyperkit;;
   *)
     minikube config set vm-driver virtualbox;;
esac

( minikube status ) || minikube start --kubernetes-version=${KUBERNETES_VERSION} --nodes 2


# enable metrics server
minikube addons enable metrics-server

MINIKUBE_IP=`minikube ip`


echo
echo "Cool! MiniKube is up on ${MINIKUBE_IP} address."
