#!/usr/bin/env bash

set -e

function setup_requirements () {
    platform='unknown'
    unamestr=`uname`
    if [[ "${unamestr}" == 'Linux' ]]; then
        platform='linux'
        minikube addon ambassador 
    elif [[ "${unamestr}" == 'Darwin' ]]; then
        platform='Darwin'
        echo "Detected Apple MacOS. Installing getops via brew."
        brew install gnu-getopt
        echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile
        minikube addon ambassador 
    else
        echo "[WARNING] This script is not supported on Windows."
        exit 0
    fi
    echo "${FUNCNAME[0]} Ended"
}

setup_requirements
