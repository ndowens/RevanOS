{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    xfce.thunar
    vesktop
    gst_all_1.gst-libav
    inputs.khanelivim.packages.x86_64-linux.default
  ];
}
