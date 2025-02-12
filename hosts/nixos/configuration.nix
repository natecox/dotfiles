# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/suspend-then-hibernate.nix
    # ../../modules/nixos/budgie.nix
    # ../../modules/nixos/cinnamon.nix
    # ../../modules/nixos/cosmic.nix
    # ../../modules/nixos/gnome.nix
    # ../../modules/nixos/hyprland.nix
    ../../modules/nixos/kde.nix
    # ../../modules/nixos/sway.nix
  ];

  # Framework specific changes
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.fprintd.enable = true;

  # Power Management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services.thermald.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Bootloader.
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [ "initcall_blacklist=simpledrm_platform_driver_init" ];

    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    initrd.systemd.enable = true;
    initrd.luks.devices."luks-ae91a3e1-56cb-49dc-8d33-adcf6a65dccf".device =
      "/dev/disk/by-uuid/ae91a3e1-56cb-49dc-8d33-adcf6a65dccf";

    # Secure boot
    # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
    # https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking.hostName = "framework13"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [
    "nix-command"
    "flakes "
  ];

  virtualisation.docker.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    videoDrivers = [ "modesetting" ];

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "colemak_dh";
    };

    excludePackages = with pkgs; [ xterm ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.fish.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      monaspace
      nerd-fonts.agave
      nerd-fonts.fantasque-sans-mono
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.natecox = {
    isNormalUser = true;
    description = "Nate Cox";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;

    packages =
      (with pkgs; [
        blightmud
        (calibre.override {
          unrarSupport = true;
        })
        floorp
        orca-slicer
        openscad-unstable
        rclone
      ])
      ++ (with pkgs-stable; [
        # orca-slicer
      ]);
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "natecox" = {
        imports = [
          ./home.nix
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnumake
    powertop
    kanata

    plover.dev
    (vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
    }))
    chromium
    vial
    via

    # Secure boot
    sbctl
  ];

  services.udev.packages = with pkgs; [
    vial
    via
  ];

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = lib.mkDefault pkgs.pinentry-all;
  };
  services.pcscd.enable = true;

  programs = {
    firefox.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
