{ pkgs, ... }:
let
  user = "natecox";
  system = "x86_64-linux";
in {
  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.05";
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionVariables = {
      TERM = "xterm-256color";
      COLORTERM = "24bit";
    };

    # packages = with pkgs; [ nixgl.nixGLDefault ];
  };

  imports = [ ../modules/home-manager ];

  programs.git.extraConfig = {
    user = {
      name = "Nate Cox";
      email = "nate@natecox.dev";
    };
  };
}
