#!/bin/bash

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

setup_sbuild() {
    echo "Setting up sbuild..."

    # install required packages
    sudo apt-get install sbuild debhelper ubuntu-dev-tools piuparts

    # setup user
    adduser "$USER" sbuild

    # create required directories
    mkdir -p "$HOME"/ubuntu/scratch
    mkdir -p "$HOME"/ubuntu/logs
    mkdir -p "$HOME"/ubuntu/build

    # setup mountpoints inside schroot
    echo "$HOME/ubuntu/scratch    /scratch    none    rw,bind    0    0" | sudo tee -a /etc/schroot/sbuild/fstab
    echo "$HOME                   $HOME       none    rw,bind    0    0" | sudo tee -a /etc/schroot/sbuild/fstab

    # create .sbuildrc in home directory
    cat >"$HOME"/.sbuildrc <<EOT
# Name to use as override in .changes files for the Maintainer: field
# (mandatory, no default!).
$maintainer_name='Mateus Rodrigues de Morais <mateus.morais@canonical.com>';

# Default distribution to build.
$distribution = "noble";
# Build arch-all by default.
$build_arch_all = 1;

# When to purge the build directory afterwards; possible values are "never",
# "successful", and "always".  "always" is the default. It can be helpful
# to preserve failing builds for debugging purposes.  Switch these comments
# if you want to preserve even successful builds, and then use
# "schroot -e --all-sessions" to clean them up manually.
$purge_build_directory = 'successful';
$purge_session = 'successful';
$purge_build_deps = 'successful';
# $purge_build_directory = 'never';
# $purge_session = 'never';
# $purge_build_deps = 'never';

# Directory for writing build logs to
$log_dir=$ENV{HOME}."/ubuntu/logs";

# don't remove this, Perl needs it:
1;
EOT

    # create .mk-sbuild.rc in home directory
    cat >"$HOME"/.mk-sbuild.rc <<EOT
SCHROOT_CONF_SUFFIX="source-root-users=root,sbuild,admin
source-root-groups=root,sbuild,admin
preserve-environment=true"
# you will want to undo the below for stable releases, read `man mk-sbuild` for details
# during the development cycle, these pockets are not used, but will contain important
# updates after each release of Ubuntu
SKIP_UPDATES="1"
SKIP_PROPOSED="1"
# if you have e.g. apt-cacher-ng around
# DEBOOTSTRAP_PROXY=http://127.0.0.1:3142/
EOT

    # create schroot for release
    sg sbuild
    mk-sbuild noble
}