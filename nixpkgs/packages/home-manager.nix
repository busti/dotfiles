{pkgs, config, ...}: let
  # figure out `nixpkgs` release, since `home-manager` requires matching
  # releases for compatibility
  version = (import <nixpkgs/nixos> {}).config.system.stateVersion;
  src = builtins.fetchGit {
    name = "home-manager-${version}";
    url = https://github.com/nix-community/home-manager;
    ref = "release-${version}";
  };
in pkgs.callPackage "${src}/home-manager" { path = "${src}"; }