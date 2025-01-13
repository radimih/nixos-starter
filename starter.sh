#!/usr/bin/env bash

echo Hello from new script without exit, Radimir! | cowsay | lolcat
echo
echo -n "Hostname: "
read -r host
echo "Host = $host"
