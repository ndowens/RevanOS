{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    flatpak
    kdePackages.discover
    tailscale
    mosh
    distrobox
    home-manager
    inputs.fh.packages.x86_64-linux.default
  ];
}
