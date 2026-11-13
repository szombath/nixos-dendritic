{ config, ... }:
{
  configurations.nixos.apollo = {
    # System options
    stateVersion = "26.05";
    wallpaper = ../../../wallpapers/nix.png;
    base16Scheme = "gruvbox-dark-hard";

    # Modules
    module = {
      imports = with config.flake.modules.nixos; [
        bluetooth
        docker
        plymouth
        podman

        # CORE
        core

        # DESKTOP
        gdm
        gnome
        desktop
        bitwarden

        # SERVICES
        cockpit
        tailscale
      ];

      openssh.extraConfig = ''
      '';

      cockpit.openTailscale = true;
    };
  };
}
