{
  description = "RevanOS";
  #ZaneyOS with my setup choice

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:dc-tec/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
    url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    hyprpanel,
    chaotic,
    home-manager,
    lix-module,
    ...
  } @ inputs: let
    system = "x86_64-v3-linux";
    host = "Revan";
    profile = "Revan";
    username = "ndowens";
    nixpkgsConfig = {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        hyprpanel.overlay
      ];
    };
  in {
    nixosConfigurations = {
      Revan = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/Revan
          home-manager.nixosModules.default
          chaotic.nixosModules.default
          nixpkgsConfig
	  lix-module.nixosModules.default
        ];
      };
    };
  };
}
