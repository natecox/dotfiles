{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    kitty
    pavucontrol
    pulseaudio
    pamixer
    playerctl
    swaynotificationcenter
    wev
    udiskie
    (catppuccin-sddm.override {
      flavor = "mocha";
    })
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  services = {
    # Automount
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    # Power Management
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
    };
    thermald.enable = true;

    gnome.gnome-keyring.enable = true;
  };
}
