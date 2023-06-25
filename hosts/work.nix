{ config, lib, pkgs, ... }:
let user = "ncox";
in {
  users.users.${user} = { home = "/Users/${user}"; };

  nix.settings.trusted-users = [ "root" user ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit user; };

  home-manager.users.${user} = { config, pkgs, lib, ... }: {
    home.stateVersion = "23.05";

    imports = [ ../modules/home-manager ];

    programs.git.extraConfig = {
      user = {
        name = "Nate Cox";
        email = "ncox@covermymeds.com";
      };
    };
  };
}
