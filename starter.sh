#!/usr/bin/env bash

echo Hello from script, Radimir! | cowsay | lolcat
echo
echo -n "Hostname: "
read -r host
echo "Host = $host"
exit 0
