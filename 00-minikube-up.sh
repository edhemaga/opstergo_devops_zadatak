#!/usr/bin/env bash

set -e

# variables
source ./_init_variables.sh
source ./01-check-machine.sh

CPU_ARCH_TYPE=$(check_cpu_architecture)

sh ./02-install-dependencies.sh

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
    if [ $CPU_ARCH_TYPE -eq 1 ]; then 
        #Docker needs to be running, therefore the script should start docker deamon
        open -a Docker
        #Added a check whether docker daemon is running in order for minikube starting not to fail
        until docker version > /dev/null 2>&1
            do
                sleep 1
        done
        #Since Hyperkit is not supported on M1 an adjustment was made
        minikube config set driver docker
    elif [ $CPU_ARCH_TYPE -eq 2 ]; then 
        minikube config set vm-driver hyperkit
    else
        echo "CPU architecture not recognized."
    fi
    ;;
   *)
    minikube config set vm-driver virtualbox;;
esac

( minikube status ) || minikube start --kubernetes-version=${KUBERNETES_VERSION} --nodes 2

kubectl apply -f kubernetes/sts.yaml

chmod +x ./03-redis-import.sh
sh ./03-redis-import.sh
# enable metrics server
minikube addons enable metrics-server

MINIKUBE_IP=`minikube ip`

kubectl create namespace redis

echo
echo "Cool! MiniKube is up on ${MINIKUBE_IP} address."
