{ pkgs, inputs, ... }:
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
