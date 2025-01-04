{ pkgs, ... }:
{
  services = {
    xserver.enable = true;

    displayManager.sddm = {
      enable = true;
      enableHidpi = true;

      wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kgpg
  ];
}
