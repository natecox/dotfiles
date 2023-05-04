{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    initExtra = ''
      eval "$(zoxide init zsh)"
    '';

    zplug = {
      enable = true;
      plugins = [{ name = "zsh-users/zsh-syntax-highlighting"; }];
    };
  };
}
