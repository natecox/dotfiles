{ ... }:
{
  imports = [
    ./waybar.nix
    # ./eww.nix
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
        "$mod, return, exec, kitty"
        "$mod, f, exec, firefox"
        "$mod, space, exec, rofi -show drun"
        "$mod, escape, exec, wlogout"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ", XF86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
        ", XF86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
      ];

      gestures = {
        workspace_swipe = true;
      };

      exec-once = [
        "swaync"
        "swayosd-server"
        "waybar"
        "udiskie"
      ];
    };
  };

  programs = {
    rofi = {
      enable = true;
    };

    yazi = {
      enable = true;
      catppuccin.enable = true;
    };

    sioyek.enable = true;
  };

  services = {
    swayosd.enable = true;
  };

}
