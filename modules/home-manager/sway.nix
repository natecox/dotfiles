{ ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    catppuccin.enable = true;

    config = {
      modifier = "Mod4";

      # Use kitty as default terminal
      terminal = "kitty";

      startup = [
        # Launch Firefox on start
        # { command = "firefox"; }
      ];

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "colemak_dh";
        };

        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "disabled";
          drag = "disabled";
          dwt = "enabled";
        };
      };

      output = {
        "eDP-1" = {
          scale = "1.8";
        };
      };

      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 0;
        outer = 10;
      };

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
