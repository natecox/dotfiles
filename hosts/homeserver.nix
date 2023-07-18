{ config, lib, pkgs, ... }:
let
  user = "natecox";
  system = "aarch64-linux";
in {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.05";
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionVariables = {
      TERM = "xterm-256color";
      COLORTERM = "24bit";
    };
  };

  imports = [ ../modules/home-manager ];

  programs.git.extraConfig = {
    user = {
      name = "Nate Cox";
      email = "nate@natecox.dev";
    };
  };
}
