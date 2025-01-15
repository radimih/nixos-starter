# NixOS Starter

This is a tool for initial preparation of a newly installed NixOS. It does the following:

1. Updates the file **NixOS configuration file** (`/etc/nixos/configuration.nix`):
     - changes default hostname (`nixos`)
     - enables experimental features (`flakes`, `nix-command`)

1. Generates the user's **ssh key** if it does not exist

1. _(optional)_ Downloads the contents of the main branch of the specified **GitHub repo** to the
   `~/starter-dotfiles` directory.

   ATTENTION! Repositories with old `master` branches are not supported.

All necessary input data will be requested during the execution of the tool.

## Usage

Immediately after installing the NixOS (preferably without installing the GUI), run the following command:

```bash
nix-shell https://github.com/radimih/nixos-starter/releases/latest/download/starter.tgz
```

Next, run the following command to make the changes in the NixOS configuration take effect:

```bash
sudo nixos-rebuild switch
```
