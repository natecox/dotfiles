{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    sessionVariables = rec {
      EDITOR = "hx";
      NIX_TEMPLATES_ID = "$(security find-generic-password -w -s 'cli tokens' -a 'nix templates gist')";
    };

    shellAliases = {
      nixt = "gh gist view $NIX_TEMPLATES_ID -rf";
    };

    zplug = {
      enable = true;
      plugins = [{ name = "zsh-users/zsh-syntax-highlighting"; }];
    };
  };
}
