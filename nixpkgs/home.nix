{config, pkgs, ...}: let
  system = (import <nixpkgs/nixos> {}).config;
in {
  home.packages = with pkgs; [
    # home-manager userspace install
    coreutils
    # noncoreutils
    ripgrep nmap
    # applications
    jetbrains.idea-community jetbrains.webstorm jetbrains.clion
    openscad prusa-slicer freecad
    dfeet qdirstat
  ];

  programs = {
    home-manager.enable = true;
  };
}