{config, pkgs, ...}: let
  optimus_java_launcher = pkgs.writeShellScriptBin "minecraft_java_launcher" ''
    exec -a "$0" optirun /nix/store/p21v8k2jzmkvr2zlqpv1y11jrdsfm43w-openjdk-16+36/bin/java "$@"
  '';

  system = (import <nixpkgs/nixos> {}).config;
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    coreutils
    # utils
    ripgrep nmap
    # applications
    jetbrains.idea-community jetbrains.webstorm jetbrains.clion
    openscad prusa-slicer freecad kicad
    dfeet qdirstat remmina
    spotify
    # games
    minecraft superTuxKart
  ];

  programs = {
    home-manager.enable = true;
  };
}
