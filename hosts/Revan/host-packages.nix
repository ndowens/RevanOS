{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    flatpak
    kdePackages.discover
    tailscale
    mosh
    distrobox
    home-manager
    inputs.fh.packages.x86_64-linux.default
  ];
}
