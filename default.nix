with import <nixpkgs> {};
mkShellNoCC {

  packages = with pkgs; [
    cowsay
    lolcat
  ];

  shellHook = builtins.readFile ./starter.sh;

#  shellHook = ''
#    echo Hello, Radimir! | cowsay | lolcat
#    echo
#    echo -n "Hostname: "
#    read -r host
#    echo "Host = $host"
#    exit 0
#    '';
}
