{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC {

  packages = with pkgs; [
    unzip
  ];

  # Run starter.sh script and immediately exit from nix shell
  shellHook = builtins.readFile ./starter.sh + "\nexit 0";
}
