#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

source ./scripts/configure-sbuild.sh
source ./scripts/configure-autopkgtest.sh

# 1: setup sbuild
setup_sbuild

# 2: setup autopkgtest
setup_autopkgtest