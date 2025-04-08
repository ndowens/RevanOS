{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    xfce.thunar
    #    vesktop
    legcord
    gst_all_1.gst-libav
    unzip # Needed for ESO price updater
  ];
}
