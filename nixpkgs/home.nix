{config, pkgs, ...}: let
  optimus_java_launcher = pkgs.writeShellScriptBin "minecraft_java_launcher" ''
    exec -a "$0" optirun /nix/store/p21v8k2jzmkvr2zlqpv1y11jrdsfm43w-openjdk-16+36/bin/java "$@"
  '';

  primecraft = pkgs.minecraft.override rec {
    jre = pkgs.jre.overrideAttrs (old@{installPhase ? "", ...}: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper pkgs.primus ];
      installPhase = installPhase + ''
        mv $out/bin/java $out/bin/.java-wrapped
        echo "#! ${pkgs.bash}/bin/bash" >> $out/bin/java
        echo "script_dir=\$(dirname \$(readlink --canonicalize-existing \$0))" >> $out/bin/java
        echo "export vblank_mode=0" >> $out/bin/java
        echo 'primusrun $script_dir/.java-wrapped "$@"' >> $out/bin/java
        chmod +x $out/bin/java
      '';
    });
  };

  insmellyj = with pkgs; jetbrains.idea-community.overrideAttrs (old@{fixupPhase ? "", ...}: {
    fixupPhase = fixupPhase + ''
      (
        wrapProgram $out/bin/idea-community \
          --prefix PATH : "${scala}/bin" \
          --prefix PATH : "${sbt}/bin" \
          --prefix PATH : "${erlang}/bin" \
          --prefix PATH : "${elixir}/bin" \
          --prefix PATH : "${nodejs}/bin" \
          --prefix PATH : "${docker}/bin" \
          --prefix PATH : "${docker-compose}/bin"
      )
    '';
  });

  system = (import <nixpkgs/nixos> {}).config;
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    coreutils
    # utils
    ripgrep nmap
    # applications
    insmellyj jetbrains.webstorm jetbrains.clion
    openscad prusa-slicer freecad kicad
    dfeet qdirstat remmina
    spotify
    # games
    steam primecraft superTuxKart
  ];

  programs = {
    home-manager.enable = true;
  };
}
