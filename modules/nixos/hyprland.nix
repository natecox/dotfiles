{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  environment.systemPackages = with pkgs; [
    kitty
    swaynotificationcenter
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Noto Sans";
      fontSize = "9";
      loginBackground = false;
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
}
