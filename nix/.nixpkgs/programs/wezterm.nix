{ config, lib, pkgs, callPackage, ... }: 
{
  programs.wezterm = {
    enable = true;

    package = pkgs.wezterm;

    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = 14.0
      }
    '';
  };
}
