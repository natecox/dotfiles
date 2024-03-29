{ config, lib, pkgs, ... }: {

  disabledModules = [ "targets/darwin/linkapps.nix" ];

  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./git-cliff.nix
    ./helix.nix
    ./kitty.nix
    ./lazygit.nix
    # ./neovim.nix
    ./nushell.nix
    ./starship.nix
    ./zsh.nix
    ./fish.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    (aspellWithDicts (d: [ d.en ]))
    cmake
    coreutils
    delta
    gh
    # jetbrains-mono
    # intel-one-mono
    (nerdfonts.override { fonts = [ "Agave" ]; })
    nerd-font-patcher
    nil
    nixfmt
    tree
    nodePackages.yaml-language-server
    zoxide
    pijul
    lunarvim
    jq
  ];

  home.sessionVariables = { EDITOR = "hx"; };

  home.file.".config/nushell/.zoxide.nu".source = ../zoxide.nu;

  manual.manpages.enable = false;

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
