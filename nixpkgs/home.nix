{config, pkgs, ...}: let
  system = (import <nixpkgs/nixos> {}).config;
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # home-manager userspace install
    coreutils
    # noncoreutils
    ripgrep nmap
    # applications
    jetbrains.idea-community jetbrains.webstorm jetbrains.clion
    openscad prusa-slicer freecad kicad
    dfeet qdirstat remmina
  ];

  programs = {
    home-manager.enable = true;
  };
}
