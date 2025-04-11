{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./chaotic.nix
    ./flatpak.nix
    ./fonts.nix
    ./greetd.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./power-profiles-daemon.nix
    ./printing.nix
    ./security.nix
    ./services.nix
    ./starfish.nix
    ./steam.nix
    ./stylix.nix
    ./system.nix
    ./thunar.nix
    ./user.nix
    ./virtualisation.nix
    ./xserver.nix
    inputs.stylix.nixosModules.stylix
  ];
  #  nix.package = pkgs.nixVersions.latest;
}
