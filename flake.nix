{
  description = "RevanOS";
  #ZaneyOS with my setup choice

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
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
    khanelivim.url = "github:khaneliman/khanelivim";
    rebuild-wrapper.url = "github:aloshy-ai/nix-rebuild-wrapper";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3.2.0";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
  };
  outputs =
    {
      self,
      nixpkgs,
      hyprpanel,
      chaotic,
      khanelivim,
      determinate,
      fh,
      ...
    }@inputs:
    let
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
    in
    {
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
            inputs.home-manager.nixosModules.default
            chaotic.nixosModules.default
            nixpkgsConfig
            determinate.nixosModules.default
          ];
        };
      };
    };
}
