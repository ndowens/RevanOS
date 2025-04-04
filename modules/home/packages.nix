{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    xfce.thunar
    lutris
    vesktop
    gst_all_1.gst-libav
  ];
}
