{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC {

  packages = with pkgs; [
    cowsay
    lolcat
  ];

  shellHook = builtins.readFile ./starter.sh;
}
