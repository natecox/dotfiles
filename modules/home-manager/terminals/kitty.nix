{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "Agave Nerd Font";
      size = 14;
    };

    settings = {
      confirm_os_window_close = 0;
      enabled_layouts = "tall";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      window_padding_width = 10;
      placement_strategy = "center";
      macos_option_as_alt = "yes";
    };
  };
}
