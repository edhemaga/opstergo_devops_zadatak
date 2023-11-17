#!/usr/bin/env bash

function check_os_type {
    #Check the OS type and convert the type to lower case for easier comparison
    local os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    #Here custom return codes were added which will be later on used for installation of needed files
    case $os_type in 
        "darwin") echo 1
        ;;
        "linux") echo 2
        ;;
        "*") echo 3
        ;;
    esac
}

function check_cpu_architecture {
    local arch_type=$(uname -p | tr '[:upper:]' '[:lower:]')
    case $arch_type in
        "arm") echo 1
        ;;
        "x86_64") echo 2
        ;;
        "*") echo 2
        ;;
    esac
}

#Check if docker is installed on the system
function check_docker {
    if command -v docker &> /dev/null; then
        echo 0
    else
        echo 1
    fi
}

function check_hyperkit {
    if command -v hyperkit &> /dev/null; then
        echo 0
    else
        echo 1
    fi
}

function check_minikube {
    if command -v minikube &> /dev/null; then
        echo 0
    else
        echo 1
    fi
}
