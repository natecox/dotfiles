{ config, lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [ tmuxPlugins.catppuccin ];
    prefix = "C-t";
    mouse = true;

    extraConfig = ''
      set -g @catppuccin_flavour 'mocha'
      set -g @catppuccin_no_patched_fonts_theme_enabled on
    '';
  };
}
