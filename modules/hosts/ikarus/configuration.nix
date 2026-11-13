{ config, ... }:
{
  configurations.nixos.ikarus = {
    # System options
    stateVersion = "26.05";
    wallpaper = ../../../wallpapers/lighthouse.png;
    base16Scheme = "catppuccin-mocha";

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
        sddm
        kde
        desktop
        fingerprint
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
