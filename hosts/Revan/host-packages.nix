{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    flatpak
    kdePackages.discover
    tailscale
    mosh
    distrobox
  ];
}
