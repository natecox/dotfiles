{
  description = "Nate's awesome dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, neovim-nightly-overlay
    , neorg-overlay, ... }: {
      nixpkgs.overlays = [
        neovim-nightly-overlay.overlays.default
        neorg-overlay.overlays.default
      ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      defaultPackage.aarch64-linux = home-manager.defaultPackage.aarch64-linux;

      darwinConfigurations = {
        
        "Nates-MBP" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/home.nix
          ];
        };

        "CMMC02G7232ML7L" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/work.nix
          ];
        };

        "CMMG2YGKGYYXJ" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/work.nix
          ];
        };
      };

      homeConfigurations = {
       "natecox" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./hosts/homeserver.nix ];
        };
      };
    };
}
