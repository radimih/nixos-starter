with import <nixpkgs> {};
mkShellNoCC {

  packages = with pkgs; [
    cowsay
    lolcat
  ];

  shellHook = ''
    echo Hello, Radimir! | cowsay | lolcat
    echo
    echo -n "Hostname: "
    read -r host
    echo "Host = $host"
    exit 0
    '';
}
