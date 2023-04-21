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

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , neovim-nightly-overlay
    , neorg-overlay
    , ...
    }@inputs: {
      nixpkgs.overlays = [
        neovim-nightly-overlay.overlays.default
        neorg-overlay.overlays.default
      ];

      darwinConfigurations."Nates-MBP" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./modules/darwin
          ./hosts/home.nix
        ];
      };
      darwinConfigurations."CMMC02G7232ML7L" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./modules/darwin
          ./hosts/work.nix
        ];
      };
    };
}
