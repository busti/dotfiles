{config, lib, pkgs, ...}: let
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

  wrapEnv = package: executable: additions: package.overrideAttrs (old@{fixupPhase ? "", ...}: let
    prefixes = lib.strings.concatMapStrings (pkg: ''--prefix PATH : "${pkg}/bin" \'' + "\n") additions;
  in {
    fixupPhase = fixupPhase + ''
      wrapProgram $out/bin/${executable} \
        ${prefixes}
    '';
  });

  insmellyj = with pkgs; (wrapEnv
    jetbrains.idea-ultimate "idea-ultimate"
    [glib docker docker-compose jdk16_headless scala sbt erlang elixir nodejs yarn inotify-tools]
  );

  naIon = with pkgs; (wrapEnv
    jetbrains.clion "clion"
    [glib gnumake cmake gcc clang nodejs nodePackages.webpack inotify-tools rustup wasm-pack trunk]
  );

  system = (import <nixpkgs/nixos> {}).config;
in {
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      coreutils
      # utils
      ripgrep nmap
      wireguard
      # applications
      insmellyj naIon jetbrains.webstorm
      openscad prusa-slicer freecad kicad
      dfeet qdirstat remmina
      spotify
      # games
      steam primecraft superTuxKart
    ];

    sessionVariables = {
      LD_PRELOAD = "${pkgs.glibc}/bin";
    };
  };

  programs = {
    home-manager.enable = true;
  };

  services = {
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
