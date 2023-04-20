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
        theme = "catppuccin_mocha";
      
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

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-buffer
      nvim-snippy 
      cmp-snippy
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-treesitter.withAllGrammars
      catppuccin-nvim
      plenary-nvim
      neorg
      lspkind-nvim
    ]; 

    extraConfig = ''
      colorscheme catppuccin

      lua << EOF
        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true,
          }
        }

        local cmp = require("cmp")
        local lspkind = require("lspkind")
        
        cmp.setup {
          snippet = {
            expand = function(args)
              require("snippy").expand_snippet(args.body)
            end
          },

          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),

          sources = {
            { name = 'snippy' },
            { name = 'neorg' },
            { name = 'buffer' },
          },

          formatting = {
            format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
          }
        }

        vim.cmd [[
          set completeopt=menuone,noinsert,noselect
          highlight! default link CmpItemKind CmpItemMenuDefault
        ]]

        require('snippy').setup({
            mappings = {
                is = {
                    ['<Tab>'] = 'expand_or_advance',
                    ['<S-Tab>'] = 'previous',
                },
                nx = {
                    ['<leader>x'] = 'cut_text',
                },
            },
        })

        require("mason").setup()
        require("mason-lspconfig").setup {
          ensure_installed = { }
        }

        require("neorg").setup {
          load = {
            ["core.defaults"] = {},
            ["core.norg.dirman"] = {
              config = {
                workspaces = {
                  work = "~/notes/work",
                }
              }
            },
            ["core.norg.completion"] = {
              config = {
                engine = "nvim-cmp"
              }
            },
          }
        }
      EOF
    '';
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

  programs.kitty = {
    enable = true;

    theme = "Catppuccin-Mocha";

    font = {
      name = "JetBrains Mono";
      size = 14;
    };
     
    settings = {
      enabled_layouts = "tall";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
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
