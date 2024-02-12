#! /usr/bin/env bash
sudo nixos-rebuild switch --flake "$PWD#$HOSTNAME"

