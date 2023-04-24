{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    shellAliases = { nixt = "gh gist view $NIX_TEMPLATES_ID -rf"; };

    initExtra = ''
      eval "$(zoxide init zsh)"
    '';

    zplug = {
      enable = true;
      plugins = [{ name = "zsh-users/zsh-syntax-highlighting"; }];
    };
  };
}
