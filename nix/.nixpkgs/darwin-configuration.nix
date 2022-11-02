{ config, pkgs, ... }:

let
  user = builtins.getEnv "USER";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
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

  # Set macOS defaults (https://github.com/LnL7/nix-darwin/tree/master/modules/system/defaults)
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically =
    true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;

  users.users.${user} = { home = "/Users/${user}"; };

  home-manager.users.${user} = { pkgs, ... }: {
    home.stateVersion = "21.11";

    imports = [
      ./programs/starship.nix
      ./programs/fzf.nix
      ./programs/zsh.nix
      ./programs/direnv.nix
    ];

    home.packages = with pkgs; [
      (aspellWithDicts (d: [ d.en ]))
      coreutils
      victor-mono
      nixfmt
      iosevka
      unstable.iosevka-comfy.comfy
    ];
  };
}
