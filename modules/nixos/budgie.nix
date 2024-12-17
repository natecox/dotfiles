{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;

      desktopManager.budgie.enable = true;
      displayManager.lightdm.enable = true;
    };
  };

  environment.budgie.excludePackages = with pkgs; [
    mate.mate-terminal
  ];
}
