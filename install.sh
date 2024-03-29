#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix

script_dir=$(dirname $(readlink --canonicalize-existing $0))

( cd $script_dir
  mkdir --parents $HOME/.config/nixpkgs
  rm -rf $HOME/.config/nixpkgs/*
  ln -sdf $script_dir/nixpkgs/* $HOME/.config/nixpkgs/

  home-manager switch
)