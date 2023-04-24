{ config, lib, pkgs, ... }:
let user = "natecox";
in
{
  users.users.${user} = { home = "/Users/${user}"; };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit user; };

  home-manager.users.${user} = { config, pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    imports = [ ../modules/home-manager ];

    programs.git = {
      enable = true;

      extraConfig = {
        user = {
          name = "Nate Cox";
          email = "nate@natecox.dev";
        };

        core.excludesfile = "$HOME/.gitignore_global";
        diff.tool = "opendiff";
        merge.tool = "opendiff";
        init.defaultBranch = "main";
        push.default = "simple";
        pull.ff = "only";
      };
    };

    home.file.".pypirc".source = ../modules/pypirc;
  };
}
