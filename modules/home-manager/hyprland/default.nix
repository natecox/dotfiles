{ ... }:
{
  imports = [
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      input = {
        kb_layout = "us";
        kb_variant = "colemak_dh";

        touchpad = {
          natural_scroll = true;
          tap-to-click = false;
          clickfinger_behavior = true;
        };

      };

      device = [
        {
          name = "corne-keyboard";
          kb_layout = "us";
          kb_variant = "";
        }
      ];

      bind = [
        "$mod, q, killactive,"
        "$mod, k, exec, kitty"
        "$mod, f, exec, firefox"
        "$mod, space, exec, rofi -show drun"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ", XF86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
        ", XF86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
      ];

      gestures = {
        workspace_swipe = true;
      };

      exec-once = [
        "swaync"
        "waybar"
      ];
    };
  };

  programs.rofi = {
    enable = true;
  };
}
