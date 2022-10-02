{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.natecox = {
    name = "natecox";
    home = "/Users/natecox";
  };

  home-manager.users.natecox = { pkgs, ... }: {
    home.stateVersion = "21.11";

    imports = [
      ./programs/starship.nix
      ./programs/fzf.nix
      ./programs/zsh.nix
      ./programs/direnv.nix
    ];

    home.packages = with pkgs; [ aspell coreutils victor-mono nixfmt ];
  };
}
