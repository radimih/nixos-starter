with (import <nixpkgs> {});
mkShellNoCC {
  packages = with pkgs; [
    cowsay
    lolcat
  ];
}
