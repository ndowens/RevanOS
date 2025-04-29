{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    flatpak
    kdePackages.discover
    tailscale
    mosh
    distrobox
    home-manager
  ];
}
