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

  programs = {
    gnupg.agent = {
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  security.pam.services.sddm.kwallet.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kgpg
  ];
}
