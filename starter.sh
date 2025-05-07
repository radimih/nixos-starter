#!/usr/bin/env bash

set -euo pipefail

DOTFILES_SUBDIR=starter-dotfiles
NIXOS_CONFIG_FILE=/etc/nixos/configuration.nix

main() {

    local begin_msg="
This script does the following:

1. Updates the file \033[1mNixOS configuration file\033[22m ($NIXOS_CONFIG_FILE):
     - changes default hostname
     - enables experimental features
     - adds the git program to the system packages

2. Generates the user's \033[1mssh key\033[22m if it does not exist

3. Downloads the contents of the main branch of the \033[1mGitHub dotfiles repo\033[22m to the
   ~/$DOTFILES_SUBDIR directory. ATTENTION! Not supported old 'master' branch.

Let's go!
---------
"
    local end_msg="
Run the following commands to make the changes in the NixOS configuration take effect:

  \033[1msudo nixos-rebuild switch\033[22m
  \033[1mreboot\033[22m
"

    local hostname_current=$(sed --silent -E 's/.*hostName = "(.*)".*/\1/p' $NIXOS_CONFIG_FILE)
    local hostname_new
    local github_repo

    clear
    echo -e "$begin_msg"

    echo -n "Enter new hostname ([Enter] - leave current hostname = '$hostname_current'): "
    read -r hostname_new
    echo -n "Optionally, enter dotfiles GitHub repo in form user/repo (for example, 'radimih/nixdots'): "
    read -r github_repo
    echo
    if [[ -z "$hostname_new" ]]; then hostname_new=$hostname_current; fi

    step_1_update_config $hostname_current $hostname_new
    step_2_generate_ssh_key $hostname_new
    step_3_download_dotfiles "$github_repo"

    echo -e "$end_msg"
}

step_1_update_config() {

    local hostname_current=$1
    local hostname_new=$2
    local experimental_param='nix.settings.experimental-features'
    local experimental_features='[ "flakes" "nix-command" "pipe-operators" ]'
    local git_package='git  # Necessary for working with flakes'

    echo "Running step 1 (updating configuration.nix)..."
    echo

    sudo --validate
    echo

    if [[ "$hostname_new" == "$hostname_current" ]]
    then
        echo ... Hostname already updated
    else
        sudo sed --in-place -E 's/^(.*hostName = ").*(".*$)/\1'$hostname_new'\2/' $NIXOS_CONFIG_FILE
        echo ... Hostname updated
    fi

    if ! grep --silent --no-messages "$experimental_param" $NIXOS_CONFIG_FILE
    then
        sudo sed --in-place "/  imports =/i\  $experimental_param = $experimental_features;\n" $NIXOS_CONFIG_FILE
        echo ... Experimental features enabled
    else
        echo ... Experimental features already enabled
    fi

    if ! grep --silent --no-messages "$git_package" $NIXOS_CONFIG_FILE
    then
        sudo sed --in-place "/environment.systemPackages = with pkgs; \[/a\ \ \ \ $git_package" $NIXOS_CONFIG_FILE
        echo ... git program added
    else
        echo ... git program already added
    fi

    echo
}

step_2_generate_ssh_key() {

    local hostname_new=$1
    local keyfile=$HOME/.ssh/id_ed25519

    echo "Running step 2 (generation user SSH key)..."
    echo

    if [[ -f $keyfile ]]
    then
        ssh-keygen -f $keyfile -c -C $USER@$hostname_new -q > /dev/null
        echo ... SSH key \'$keyfile\' already exists, updated key comment
    else
        # Generate key pair without passphrase
        ssh-keygen -t ed25519 -N "" -f $keyfile -C $USER@$hostname_new
    fi
    echo
}

step_3_download_dotfiles() {

    # TODO: not supported repo with old 'master' branch

    local github_repo=$1
    local dotfiles_dir=$HOME/$DOTFILES_SUBDIR
    local repo_dir=$HOME/${github_repo##*/}-main
    local repo_url=https://github.com/${github_repo}/archive/refs/heads/main.zip

    if [[ -z "$github_repo" ]]; then return; fi

    echo "Running step 3 (download dotfiles from github repository)..."
    echo

    rm -rf $dotfiles_dir ${dotfiles_dir}.zip $repo_dir
    curl --silent -L -o ${dotfiles_dir}.zip $repo_url
    unzip -q ${dotfiles_dir}.zip -d $HOME
    rm -f ${dotfiles_dir}.zip
    mv $repo_dir $dotfiles_dir

    echo ...Downloaded GitHub repo $github_repo into $dotfiles_dir
    echo
}

main
