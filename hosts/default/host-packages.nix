{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    flatpak
    kdePackages.discover
    home-manager
  ];
}
