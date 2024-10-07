{ pkgs, ... }:
{
  programs.helix = {
    enable = true;

    package = pkgs.helix;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";

        cursorline = true;

        file-picker = {
          hidden = false;
        };

        soft-wrap = {
          enable = true;
        };

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

        indent-guides = {
          render = true;
          character = "┊";
          skip_levels = 1;
        };
      };

      keys.normal = {
        "C-g" = [
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
        ];
      };
    };

    languages = {
      language-server = {
        emmet-ls = {
          command = "emmet-ls";
          args = [ "--stdio" ];
        };

        nil = {
          command = "nil";
        };
      };

      language = [
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
          language-servers = [ "nil" ];
        }

        {
          name = "html";
          language-servers = [ "emmet-ls" ];
        }
      ];
    };
  };
}

