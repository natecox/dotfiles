{ config, lib, pkgs, ... }: {

  programs.helix = {
    enable = true;

    package = pkgs.helix;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";

        soft-wrap = { enable = true; };

        statusline = {
          right = [
            "version-control"
            "diagnostics"
            "selections"
            "position"
            "position-percentage"
            "file-encoding"
          ];
        };

        lsp = { display-inlay-hints = true; };

        indent-guides = {
          render = true;
          character = "┊";
          skip_levels = 1;
        };
      };

      keys.insert = { "C-g" = "normal_mode"; };
    };

    languages = [
      {
        name = "rust";
        indent = {
          tab-width = 4;
          unit = "	";
        };
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "nixfmt";
        };
        language-server = {
          command = "rnix-lsp";
        };
      }
    ];
  };
}
