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
        "*") echo 0
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
