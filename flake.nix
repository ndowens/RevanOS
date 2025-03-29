{
  description = "RevanOS";
  #ZaneyOS with my setup choice

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixos-updatechecker = {
      url = "github:melianmiko/nixos-updatechecker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rebuild-wrapper.url = "github:aloshy-ai/nix-rebuild-wrapper";
  };

  outputs = {
    self,
    nixpkgs,
    hyprpanel,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host = "Revan";
    profile = "Revan";
    username = "ndowens";
    nixpkgsConfig = {
      nixpkgs.overlays = [
        inputs.hyprpanel.overlay
      ];
      nixpkgs.config.allowUnfree = true;
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
          inputs.nixos-updatechecker.nixosModules.nixos-updatechecker
          inputs.home-manager.nixosModules.default
          nixpkgsConfig
        ];
      };
    };
  };
}
