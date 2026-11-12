{ config, ... }:
{
  configurations.homeManager.ikarus = {
    module =
      { pkgs, ... }:
      {
        # HACK: remove permittedInsecurePackages once it's no longer a transitive dependency
        nixpkgs.config.permittedInsecurePackages = [
          "electron-40.10.5"
          "ventoy-1.1.18"
        ];

        # HACK: permit gtk2
        nixpkgs.config.problems.handlers = {
          "gtk+".broken = "warn";
        };

        imports = with config.flake.modules.homeManager; [
          discord
          easyeffects
          gtk
          latex
          librewolf
          plasma-manager
          udiskie

          # DEV
          dev
          rustpkgs

          # AI
          opencode
          herdr

          # OFFICE
          obsidian
          onlyoffice
          portfolio
        ];

        plasma-manager = {
          override = false;
          layouts = [ { layout = "de"; } ];
        };

        home.packages = with pkgs; [
          winboat # windows as a container
          nextcloud-client # nextcloud desktop
          yacreader # comic reader
          dbeaver-bin # db manager
          qbittorrent-enhanced # torrent
          teams-for-linux # teams
          bruno # package sender
        ];
      };
  };
}
