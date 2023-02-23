{ config, lib, pkgs, callPackage, ... }: {

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  
  programs.emacs = {
    enable = true;
    
    package = pkgs.emacsUnstable.override { nativeComp = true; };
    extraPackages = epkgs: with epkgs; [ vterm ];
  };
}
