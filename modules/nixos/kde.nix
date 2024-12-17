{ ... }:
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
}
