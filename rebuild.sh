#! /usr/bin/env bash
full_host=$HOSTNAME

# mac adds this and I don't want it
host=${full_host%".local"}
host=${host%".lan"}
 
if [ $host == "sigdis" ]; then
  darwin-rebuild switch --flake "$PWD#$host"
elif [ $host == "unidel" ]; then
  sudo nixos-rebuild switch --flake "$PWD#$host"
fi
