{ ... }:
{
  programs.waybar = {
    enable = true;
    catppuccin.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/windows"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "tray"
          "custom/lock"
          "custom/power"
        ];
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        pulseaudio = {
          format = " {volume}%";
          on-click = "pavucontrol";
        };
      }
    ];

    style = builtins.readFile ./waybar.css;
  };
}
