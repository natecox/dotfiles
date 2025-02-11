{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    settings = {
      font-family = "Monaspace Radon Var";
      font-size = 13;
    };
  };
}
