{config, lib, pkgs, ...}: {
  
  users.users.natecox = {
    home = "/Users/natecox";
  };

  home-manager.users.natecox = { config, pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    imports = [ ../common/packages.nix ];

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

    home.file.".pypirc".source = ./pypirc;
  };
}