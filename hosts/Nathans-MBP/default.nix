{config, lib, pkgs, ...}: {
  
  users.users.natecox = {
    home = "/Users/natecox";
  };

  home-manager.users.natecox = { config, pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    imports = [ ../common/packages.nix ];

  };

}