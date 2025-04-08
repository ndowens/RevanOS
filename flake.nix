{
  description = "RevanOS";
  #ZaneyOS with my setup choice

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    det-nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "det-nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    hyprpanel,
    chaotic,
    home-manager,
    nvf,
    determinate,
    ...
  } @ inputs: let
    system = "x86_64-v3-linux";
    host = "Revan";
    profile = "Revan";
    username = "ndowens";
    pkgs = "import <nixpkgs> {}";
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
          determinate.nixosModules.default
        ];
      };
    };
  };
}
