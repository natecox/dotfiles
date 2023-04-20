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

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, neorg-overlay, ... }: {
    nixpkgs.overlays = [ neorg-overlay.overlays.default ];
    
    darwinConfigurations."Nathans-MBP" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
        home-manager.darwinModules.home-manager
        ./hosts/common/default.nix
        ./hosts/Nathans-MBP/default.nix
      ];
    };
    darwinConfigurations."CMMC02G7232ML7L" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
        home-manager.darwinModules.home-manager
        ./hosts/common/default.nix
        ./hosts/CMMC02G7232ML7L/default.nix
      ];
    };
  };
}
