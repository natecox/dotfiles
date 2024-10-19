{ pkgs, ... }:
{
  # services.displayManager.sddm = {
  #   enable = true;
  #   theme = "catppuccin-mocha";
  #   package = pkgs.kdePackages.sddm;
  # };

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
    wlogout
    xdg-desktop-portal-hyprland
    # (catppuccin-sddm.override {
    #   flavor = "mocha";
    # })
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

  services = {
    # Automount
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    gnome.gnome-keyring.enable = true;
    xserver.displayManager.gdm.enable = true;
  };

  security.pam.services.gdm-password.enableGnomeKeyring = true;
}
