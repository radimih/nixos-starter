with import <nixpkgs> {};
mkShellNoCC {

  packages = with pkgs; [
    cowsay
    lolcat
  ];

  shellHook = ''
    echo Hello, Radimir! | cowsay | lolcat
    echo
    '';
}
