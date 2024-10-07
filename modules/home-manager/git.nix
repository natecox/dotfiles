{ ... }:
{
  programs.git = {
    enable = true;

    extraConfig = {

      commit.gpgsign = true;

      core.excludesfile = "$HOME/.gitignore_global";
      core.pager = "delta";

      delta.side-by-side = false;

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
