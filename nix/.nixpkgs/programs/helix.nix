{ config, lib, pkgs, callPackage, ... }: 
{
  programs.helix = {
    enable = true;

    package = pkgs.helix;
  };
}
