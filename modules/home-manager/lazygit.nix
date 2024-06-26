{ ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      promptToReturnFromSubprocess = false;

      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };

      gui.theme = {
        lightTheme = "false";
        activeBorderColor = [
          "#a6e3a1"
          "bold"
        ];
        inactiveBorderColor = [ "#cdd6f4" ];
        optionsTextColor = [ "#89b4fa" ];
        selectedLineBgColor = [ "#313244" ];
        selectedRangeBgColor = [ "#313244" ];
        cherryPickedCommitBgColor = [ "#94e2d5" ];
        cherryPickedCommitFgColor = [ "#89b4fa" ];
        unstagedChangesColor = [ "red" ];
      };
    };
  };
}
