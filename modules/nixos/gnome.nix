{ ... }:
{
  services.xserver = {

    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;
  };
}
