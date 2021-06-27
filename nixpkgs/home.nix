{config, pkgs, ...}: let
  system = (import <nixpkgs/nixos> {}).config;
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    coreutils
    # noncoreutils
    ripgrep nmap
    # applications
    jetbrains.idea-community jetbrains.webstorm jetbrains.clion
    openscad prusa-slicer freecad kicad
    dfeet qdirstat remmina
    # games
    minecraft
  ];

  programs = {
    home-manager.enable = true;
  };
}
