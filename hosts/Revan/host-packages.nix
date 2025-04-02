{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    brave
    flatpak
    kdePackages.discover
    tailscale
    mosh
    distrobox
    home-manager
  ];
}
