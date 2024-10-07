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
        "$mod, Q, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, RETURN, exec, rofi -show drun"
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
