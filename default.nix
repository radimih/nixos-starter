with import <nixpkgs> {};
mkShellNoCC {

  packages = with pkgs; [
    cowsay
    lolcat
  ];

  shellHook = builtins.readFile ./starter.sh;
}
