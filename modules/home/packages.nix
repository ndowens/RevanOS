{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    heroic
    legcord
    gst_all_1.gst-libav
    unzip # Needed for ESO price updater
    keepassxc
    nix-tree
    lunar-client
    inputs.nixvim.packages.x86_64-linux.default
  ];
}
