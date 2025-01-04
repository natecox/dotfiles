{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # catppuccin.url = "github:catppuccin/nix";
    # catppuccin.url = "github:natecox/catppuccin-nix/add-ghostty";
    catppuccin.url = "git+file:///home/natecox/src/natecox/catppuccin-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-master.url = "github:helix-editor/helix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      darwin,
      catppuccin,
      lanzaboote,
      nixos-cosmic,
      helix-master,
      ...
    }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          nixos-hardware.nixosModules.framework-13th-gen-intel
          catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./hosts/nixos/configuration.nix
        ];
      };

      darwinConfigurations = {
        "Nates-MBP" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/darwin/home.nix
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
            ./hosts/darwin/work.nix
          ];
        };
      };
    };
}
