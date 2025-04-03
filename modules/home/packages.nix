{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    xfce.thunar
    lutris
    vesktop
  ];
}
