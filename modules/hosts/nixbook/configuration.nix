{ config, ... }:
{
  configurations.nixos.nixbook = {
    # System options
    stateVersion = "26.05";
    wallpaper = ../../../wallpapers/gears-in-a-machine.jpg;
    base16Scheme = "gruvbox-dark-hard";

    # Modules
    module = {
      imports = with config.flake.modules.nixos; [
        podman

        # CORE
        core

        # DESKTOP
        sddm
        kde
        desktop

        # SERVICES
        cockpit
      ];

      openssh.extraConfig = ''
      '';

      cockpit.openTailscale = true;
    };
  };
}
