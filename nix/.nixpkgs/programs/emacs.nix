{ config, lib, pkgs, ... }: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs.override { nativeComp = true; };
    extraPackages = epkgs: with epkgs; [ vterm ];
  };
}
