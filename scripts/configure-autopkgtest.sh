#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

RELEASE=$1
SETUP_AUTOPKGTEST_QEMU=$2

setup_autopkgtest() {
    echo "Setting up autopkgtest..."

    # create testbeds directory
    mkdir -p "$HOME"/testbeds

    sudo apt-get update
    sudo apt-get install -y autopkgtest

    # build images
    if $SETUP_AUTOPKGTEST_QEMU; then
        sudo apt-get install qemu-system-"$(dpkg --print-architecture)"

        popd "$HOME"/testbeds
        autopkgtest-buildvm-ubuntu-cloud -r "$RELEASE" -v
        popd
    fi
}