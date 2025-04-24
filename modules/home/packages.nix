{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    easyrpg-player
    heroic
    xfce.thunar
    legcord
    gst_all_1.gst-libav
    unzip # Needed for ESO price updater
    keepassxc
    nix-tree
    inputs.nixvim.packages.x86_64-linux.default
  ];
}
