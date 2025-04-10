{username, ...}: {
  home.file = {
    ".config/artools".source = ./configs/artools;
    ".config/pacman.d".source = ./configs/pacman.d;
    ".config/pacman.conf".source = ./configs/pacman.conf;
    ".config/makepkg.conf".source = ./configs/makepkg.conf;
    ".config/artix-checkupdates/config".source = ./configs/artix-checkupdates/config;
    ".config/nix-search-tv/config.json".source = ./configs/nix-search-tv;
  };
}
