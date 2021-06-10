#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix

nix-shell -E \
  "with import <nixpkgs> {}; mkShell { buildInputs = [ (callPackage ./modules/home-manager.nix {}) ]; }" \
  --run "home-manager -f $1 switch"
