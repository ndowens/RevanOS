{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    emacs-nox
    heroic
    legcord
    gst_all_1.gst-libav
    unzip # Needed for ESO price updater
    keepassxc
    nix-tree
    lunar-client
    maestral
  ];
}
