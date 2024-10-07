{ ... }:
{
  programs.waybar = {
    enable = true;
    catppuccin.enable = false;

    settings = [
      {
        modules-left = [
          "hyprland/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "custom/media"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          # "mpd"
          # "idle_inhibitor"
          "pulseaudio"
          # "network"
          "bluetooth"
          "power-profiles-daemon"
          # "cpu"
          # "memory"
          # "temperature"
          "backlight"
          "keyboard-state"
          "sway/language"
          "battery"
          "clock"
          "tray"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
      }
    ];
  };
}
