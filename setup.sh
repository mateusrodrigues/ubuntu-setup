#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

RELEASE='' # The current ubuntu devel release to setup a schroot for (--devel-release)

function print_usage
{
    bold_style='\033[1m'
    underline_style='\033[4m'
    reset_style='\033[0m'

    echo    ""
    echo -e "${bold_style}Usage:${reset_style} $0 --devel-release ${underline_style}release${reset_style}"
    echo    ""
    echo    "Sets up an Ubuntu development environment."
    echo    ""
    echo    "Parameter:"
    echo -e "  --devel-release ${underline_style}release${reset_style}"
    echo -e "        ${underline_style}release${reset_style} is used to determine the current devel release to setup the schroot for"
    echo    ""
    echo    "Example:"
    echo    "  $0 --devel-release noble"
    echo    ""
    echo    "Run $0 --help to show this usage information."
}

# Parse parameters:
while [ "$#" -gt "0" ]; do
    case $1 in
        --help)
            print_usage
            exit 0
            ;;
        --devel-release)
            if [ "$#" -lt "2" ]; then
                print_error "parameter --devel-release is specified, but no value was provided"
                print_usage
                exit 1
            fi

            RELEASE=$2
            shift 2
            ;;
        *)
            print_error "unexpected argument '$1'"
            print_usage
            exit 1
            ;;
    esac
done

function print_err() {
    echo "ERROR:" "$@" 1>&2;
}

# shellcheck disable=SC1091
source ./scripts/configure-sbuild.sh
# shellcheck disable=SC1091
source ./scripts/configure-autopkgtest.sh

if [ -z "$RELEASE" ]; then
    print_err "Specify a release with --devel-release"
    exit 1
fi

# 1: setup sbuild
setup_sbuild "$RELEASE"

# 2: setup autopkgtest
setup_autopkgtest