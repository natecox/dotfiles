{config, lib, pkgs, ...}: {

  disabledModules = [ "targets/darwin/linkapps.nix" ];
  
  home.packages = with pkgs; [
    (aspellWithDicts (d: [ d.en ]))
    cmake
    coreutils
    jetbrains-mono
    comic-mono
    gh
    nixfmt
    iterm2
    zoxide
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = { enable = true; };

  programs.helix = {
    enable = true;

    package = pkgs.helix;

    settings = 
      {
        theme = "kanagawa";
      
        editor = {
          line-number = "relative";

          soft-wrap = {
            enable = true;
          };

          statusline = {
            right = ["version-control" "diagnostics" "selections" "position" "position-percentage" "file-encoding"];
          };

          lsp = {
            display-inlay-hints = true;
          };

          indent-guides = {
            render = true;
            character = "┊";
            skip_levels = 1;
          };
        };

        keys.insert = {
          "C-g" = "normal_mode";
        };
      };

    languages = [
      {
        name = "rust";
        indent = { 
          tab-width = 4;
          unit = "\t";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    settings = { };
  };


  programs.wezterm = {
    enable = true;

    package = pkgs.wezterm;

    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = 14.0
      }
    '';
  };

  programs.zsh = {
    enable = true;

    sessionVariables = rec {
      EDITOR = "hx";
      NIX_TEMPLATES_ID = "$(security find-generic-password -w -s 'cli tokens' -a 'nix templates gist')";
    };

    shellAliases = {
      nixt = "gh gist view $NIX_TEMPLATES_ID -rf";
    };

    initExtra = ''
      eval "$(zoxide init zsh)"
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };
  };

  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      baseDir="$HOME/Applications/Home Manager Apps"
      if [ -d "$baseDir" ]; then
        rm -rf "$baseDir"
      fi
      mkdir -p "$baseDir"
      for appFile in ${apps}/Applications/*; do
        target="$baseDir/$(basename "$appFile")"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
      done
    '';
  };
}
