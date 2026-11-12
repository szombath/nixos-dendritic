{ config, ... }:
{
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    audio
    dconf
    network
    power
    udisk
    xdg
  ];
}
