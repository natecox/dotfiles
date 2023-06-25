{ config, lib, pkgs, ... }:
let user = "natecox";
in {
  users.users.${user} = { home = "/Users/${user}"; };

  nix.settings.trusted-users = [ "root" user ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit user; };

  home-manager.users.${user} = { config, pkgs, lib, ... }: {
    home.stateVersion = "23.05";

    imports = [ ../modules/home-manager ];

    programs.git = {
      enable = true;

      extraConfig = {
        user = {
          name = "Nate Cox";
          email = "nate@natecox.dev";
        };

        core.excludesfile = "$HOME/.gitignore_global";
        core.pager = "delta";

        diff.tool = "delta";

        init.defaultBranch = "main";

        interactive.diffFilter = "delta --color-only";

        merge.conflicStyle = "diff3";
        merge.tool = "delta";

        pull.ff = "only";

        push.default = "simple";
      };
    };

    home.file.".pypirc".source = ../modules/pypirc;
  };
}
