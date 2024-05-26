{ inputs, ... }:
let
  user = "natecox";
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
        ../modules/home-manager
        ../modules/home-manager/kitty.nix
      ];

      programs.git.extraConfig = {
        user = {
          name = "Nate Cox";
          email = "nate@natecox.dev";
        };
      };

      home.file.".pypirc".source = ../modules/pypirc;
    };
}
