#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix

script_dir=$(dirname $(readlink --canonicalize-existing $0))

mkdir --parents $HOME/.config/nixpkgs
rm -rf $HOME/.config/nixpkgs/*
ln -sdf $script_dir/nixpkgs/* $HOME/.config/nixpkgs/

nix-shell -E \
  "with import <nixpkgs> {}; mkShell { buildInputs = [ (callPackage ./nixpkgs/packages/home-manager.nix {}) ]; }" \
  --run "home-manager switch"
