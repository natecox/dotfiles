{config, lib, pkgs, ...}: {
  
  users.users.ncox= {
    home = "/Users/ncox";
  };

  home-manager.users.ncox= { config, pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    imports = [ ../common/packages.nix ];

    programs.git = {
      enable = true;

      extraConfig = {
        user = {
          name = "Nate Cox";
          email = "ncox@covermymeds.com";
        };

        core.excludesfile = "$HOME/.gitignore_global";
        diff.tool = "opendiff";
        merge.tool = "opendiff";
        init.defaultBranch = "main";
        push.default = "simple";
        pull.ff = "only";
      };
    };
  };
}