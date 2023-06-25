{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;

    extraConfig = {

      core.excludesfile = "$HOME/.gitignore_global";
      core.pager = "delta";

      delta.side-by-side = true;

      diff.tool = "delta";

      init.defaultBranch = "main";

      interactive.diffFilter = "delta --color-only";

      merge.conflicStyle = "diff3";
      merge.tool = "delta";

      pull.ff = "only";

      push.default = "simple";
    };
  };
}
