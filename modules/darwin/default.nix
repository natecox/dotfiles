{ pkgs, ... }:
{
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
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Set macOS defaults (https://github.com/LnL7/nix-darwin/tree/master/modules/system/defaults)
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;

  security.pam.enableSudoTouchIdAuth = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.variables = {
    EDITOR = "hx";
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    casks = [
      "betterdisplay"
      "gpg-suite-no-mail"
      "maccy"
      "muzzle"
      "notion"
      "proton-pass"
      "postman"
      "ghostty"

      ## browsers
      # "librewolf"
      "arc"
      "firefox"
      "floorp"
      "zen-browser"
    ];
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false;

    config = {
      layout = "bsp";
      auto_balance = "off";
      split_ratio = "0.50";

      focus_follows_mouse = "off";
      mouse_follows_focus = "off";

      window_placement = "first_child";
      window_shadow = "float";
      window_topmost = "off";
      window_zoom_persist = "off";

      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      top_padding = 10;
      window_gap = 10;

      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_modifier = "fn";
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app="^(Calculator|Software Update|Dictionary|System Preferences|System Settings|Photo Booth|Archive Utility|App Store|Steam|Activity Monitor)$" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add app="^com.microsoft.teams2.launcher$" manage=off
    '';
  };
}
