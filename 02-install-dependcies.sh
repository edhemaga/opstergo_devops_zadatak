#!/usr/bin/env bash

source ./01-check-machine.sh

OS_TYPE=$(check_os_type)

DOCKER_INSTALLED=$(check_docker)
echo $DOCKER_INSTALLED

if [ $DOCKER_INSTALLED -eq 0 ]; then
    echo "Docker already installed!"
    exit 0
else 
    #Remove binaries if they already exist so that there are no collisions when clean installing

    #TODO Isolate to separate script - 98-remove-dependencies.sh 
    current_folder=$(pwd)
    echo "Removing docker binaries..."
    cd /usr/local/bin/
    sudo rm -r docker \
        docker-compose \
        docker-credential-desktop \
        docker-credential-ecr-login \
        docker-credential-osxkeychain \
        com.docker.cli \
        kubectl \
        kubectl.docker \
        hub-tool \
        docker-compose-v1
    cd $current_folder
    echo "Docker is getting installed..."
fi

if [ $OS_TYPE == 1 ]; then
    #Check if brew is installed
    if ! command -v brew &> /dev/null; then
            echo "Homebrew not present! Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    #Install docker with Brew
    brew install --cask docker
    echo "Docker installed successfully!"
elif [ $OS_TYPE == 2 ]; then
    sudo apt-get update
    # Install required packages to allow apt to use a repository over HTTPS
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable Docker repository
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    # Install the latest version of Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    #Set user permission
    sudo usermod -aG docker $USER

    echo "Docker installed successfully!"
else
    echo "OS not recognized!"
fi
