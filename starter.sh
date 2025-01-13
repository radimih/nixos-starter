#!/usr/bin/env bash

GITHUB_REPO=radimih/nixdots
NIXOS_CONFIG_FILE=/etc/nixos/configuration.nix

main() {

    begin_msg="
This script does the following:

1. Updates the file \033[1mNixOS configuration file\033[22m ($NIXOS_CONFIG_FILE):
     - changes default hostname
     - enables experimental features

2. Generates the user's \033[1mssh key\033[22m if it does not exist

3. Clones the \033[1mGitHub dotfiles repo\033[22m ($GITHUB_REPO) to the home directory

Let's go!
---------
"
    end_msg="
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
    echo -n "Hostname: "
    read -r host
    echo "Host = $host"
}

step_2_generate_ssh_key() {
    echo
}

step_3_clone_dotfiles() {
    echo
}

main
