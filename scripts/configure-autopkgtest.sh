#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

setup_autopkgtest() {
    echo "Setting up autopkgtest..."

    # create testbeds directory
    mkdir -p "$HOME"/testbeds

    sudo apt-get install autopkgtest

    # build images
}