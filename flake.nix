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
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena
    nixvim.url = "github:dc-tec/nixvim";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      #      inputs.nixpkgs.follows = "nixos-cosmic/nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
  };
  outputs =
    {
      self,
      nixpkgs,
      hyprpanel,
      chaotic,
      home-manager,
      nix-flatpak,
      stylix,
      nixvim,
      determinate,
      nixos-cosmic,
      ...
    }@inputs:
    let
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
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            ./profiles/Revan
            home-manager.nixosModules.default
            chaotic.nixosModules.default
            nixpkgsConfig
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            determinate.nixosModules.default
            nixos-cosmic.nixosModules.default
          ];
        };
      };
    };
}
