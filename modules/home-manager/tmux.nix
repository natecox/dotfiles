{ config, lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [ tmuxPlugins.catppuccin ];
    prefix = "C-t";
    mouse = true;

    extraConfig = ''
      set -g @catppuccin_flavour 'mocha'
      set -g @catppuccin_powerline_icons_theme_enabled on
      set -g @catppuccin_window_tabs_enabled on
      set -g @catppuccin_l_left_separator ""
      set -g @catppuccin_l_right_separator ""
      set -g @catppuccin_r_left_separator ""
      set -g @catppuccin_r_right_separator ""
    '';
  };
}
