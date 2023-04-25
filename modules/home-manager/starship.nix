{ config, lib, pkgs, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 1000;
    };
  };
}
