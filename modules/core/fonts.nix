{ pkgs, ... }:

fonts = {
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
  ];

  fontconfig = {
    # Fixes pixelation
    antialias = true;

    # Fixes antialiasing blur
    hinting = {
      enable = true;
      style = "hintfull"; # no difference
      autohint = true; # no difference
    };

    subpixel = {
      # Makes it bolder
      rgba = "rgb";
      lcdfilter = "default"; # no difference
    };
  };
};
