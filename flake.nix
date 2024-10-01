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

    # helix.url = "github:helix-editor/helix/master";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }:
    {
      nixpkgs.overlays = [
        # helix.overlays.default
      ];

      defaultPackage.aarch64-linux = home-manager.defaultPackage.aarch64-linux;
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

      darwinConfigurations = {
        "Nates-MBP" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/home.nix
          ];
        };

        "CMMG2YGKGYYXJ" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/work.nix
          ];
        };
      };

      homeConfigurations = {
        "natecox" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
          };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/framework13.nix ];
        };
      };
    };
}
