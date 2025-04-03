{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    winePackages.stagingFull
    xfce.thunar
  ];
}
