{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    sessionVariables = rec {
      # EDITOR = "emacsclient";
    };

    zplug = {
      enable = true;
      plugins = [{ name = "zsh-users/zsh-syntax-highlighting"; }];
    };
  };
}
