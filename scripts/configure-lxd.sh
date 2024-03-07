#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

setup_lxd() {
    echo "Setting up lxd..."

    sudo snap install lxd

    lxd init --auto
}