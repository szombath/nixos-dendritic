{ config, ... }:
{
  configurations.homeManager.vm-nixos = {
    module =
      { pkgs, ... }:
      {
        # HACK: remove permittedInsecurePackages once it's no longer a transitive dependency
        nixpkgs.config.permittedInsecurePackages = [
          "electron-40.10.5"
          "ventoy-1.1.18"
        ];

        #pkgs = import nixpkgs {
        #  inherit system;
        #  config.permittedInsecurePackages = [
        #    "python3.12-python-jose-3.5.0"
        #  ];
        #};

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
          calibre
          obsidian
          onlyoffice
        ];

        plasma-manager.override = false;

        home.packages = with pkgs; [
          git
          btop
          vscodium

          dbeaver-bin # db manager
          bruno # package sender
          chromium
          krita # paint
          ventoy # image writer
        ];
      };
  };
}
