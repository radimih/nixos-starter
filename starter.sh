#!/usr/bin/env bash

GITHUB_REPO=radimih/nixdots
NIXOS_CONFIG_FILE=/etc/nixos/configuration.nix
# FIXME: remove
NIXOS_CONFIG_FILE=./configuration.nix

set -euo pipefail

main() {

    local begin_msg="
This script does the following:

1. Updates the file \033[1mNixOS configuration file\033[22m ($NIXOS_CONFIG_FILE):
     - changes default hostname
     - enables experimental features

2. Generates the user's \033[1mssh key\033[22m if it does not exist

3. Clones the \033[1mGitHub dotfiles repo\033[22m ($GITHUB_REPO) to the home directory

Let's go!
---------
"
    local end_msg="
Run the following command to make the changes in the NixOS configuration take effect:

  \033[1msudo nixos-rebuild switch\033[22m
"

    clear
    echo -e "$begin_msg"

    step_1_update_config
    step_2_generate_ssh_key
    step_3_clone_dotfiles

    echo -e "$end_msg"
}

step_1_update_config() {

    local hostname_new
    local hostname_current=$(sed --silent -E 's/.*hostName = "(.*)".*/\1/p' $NIXOS_CONFIG_FILE)
    local experimental_param='nix.settings.experimental-features'
    local experimental_features='[ "nix-command" "flakes" ]'

    echo Running step 1...
    echo

    echo -n "Enter hostname ([Enter] - leave current hostname = '$hostname_current'): "
    read -r hostname_new

    echo
    sudo --validate

    if [[ -n "$hostname_new" ]]
    then
        sudo sed --in-place -E 's/^(.*hostName = ").*(".*$)/\1'$hostname_new'\2/' $NIXOS_CONFIG_FILE
        echo ... Hostname updated
    else
        echo ... Hostname already updated
    fi

    if ! grep --silent --no-messages "$experimental_param" $NIXOS_CONFIG_FILE
    then
        sudo sed --in-place "/  imports =/i\  $experimental_param = $experimental_features;\n" $NIXOS_CONFIG_FILE
        echo ... Experimental features enabled
    else
        echo ... Experimental features already enabled
    fi

    sudo --remove-timestamp
    echo
}

step_2_generate_ssh_key() {

    local keyfile=$HOME/.ssh/id_ed25519

    echo Running step 2...
    echo

    if [[ -f $keyfile ]]
    then
        echo ... SSH key \'$keyfile\' already exists
    else
        # Generate key pair without passphrase
        # TODO: комментарий у ключа содержит еще предыдущее название хоста
        ssh-keygen -t ed25519 -N "" -f $keyfile
    fi
    echo
}

step_3_clone_dotfiles() {
    echo -n
}

main
