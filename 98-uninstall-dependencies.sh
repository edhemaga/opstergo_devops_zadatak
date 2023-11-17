#!/usr/bin/env bash

./99-minikube-down.sh

#Remove minikube
sudo rm -rf /usr/local/bin/minikube
sudo rm -rf /usr/local/bin/kubectl

command -v docker 2>&1 || {
    echo "Could not find docker on machine...";
    exit 1
}

#Uninstall docker
brew uninstall --cask docker