#! /usr/bin/env bash
full_host=$HOSTNAME
host=${full_host%".local"} # mac adds this and I don't want it

if [ $host == "sigdis" ]; then
  darwin-rebuild switch --flake "$PWD#$host"
elif [ $host == "unidel" ]; then
  sudo nixos-rebuild switch --flake "$PWD#$host"
fi
