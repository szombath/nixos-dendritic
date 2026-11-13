# Default shell for the user across NixOS and Android
{ config, ... }:
{
  flake.modules.nixos.user =
    { pkgs, ... }:
    {
      programs.zsh.enable = true;
      programs.bash.enable = true;
      users = {
        defaultUserShell = pkgs.bash;
        users.${config.user.username}.shell = pkgs.bash;
      };
    };
}
