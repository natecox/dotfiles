{ pkgs, ... }:

{
  home.username = "natecox";
  home.homeDirectory = "/home/natecox";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/editors/helix.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/sway.nix
    ../../modules/home-manager/lazygit.nix
    ../../modules/home-manager/terminals/fish.nix
    ../../modules/home-manager/terminals/starship.nix
    ../../modules/home-manager/terminals/ghostty.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    freecad-wayland

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  programs.git.extraConfig.user = {
    name = "Nate Cox";
    email = "nate@natecox.dev";
    signingkey = "A7E9F186";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
