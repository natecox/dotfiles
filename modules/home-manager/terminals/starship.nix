{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      command_timeout = 1000;
      format = "$all";
      directory = {
        style = "bold lavender";
      };
    };
  };
}
