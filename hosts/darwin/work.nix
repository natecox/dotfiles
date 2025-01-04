{ inputs, ... }:
let
  user = "ncox";
in
{
  users.users.${user} = {
    home = "/Users/${user}";
  };

  nix.settings.trusted-users = [
    "root"
    user
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit user inputs;
  };

  home-manager.users.${user} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.stateVersion = "23.11";

      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ../../modules/home-manager
        ../../modules/home-manager/editors/helix.nix
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/lazygit.nix
        ../../modules/home-manager/terminals/fish.nix
        ../../modules/home-manager/terminals/starship.nix
      ];

      catppuccin = {
        enable = true;
        flavor = "mocha";
        cursors.enable = true;

        gtk = {
          enable = true;
          icon.enable = true;
        };

        kvantum.enable = true;
      };

      gtk = {
        enable = true;
        gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      };

      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";
      };

      programs.git.extraConfig = {
        user = {
          name = "Nate Cox";
          email = "ncox@covermymeds.com";
          signingkey = "A7E9F186";
        };
      };

      programs.home-manager.enable = true;
    };
}
