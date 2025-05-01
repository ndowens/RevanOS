{
  host,
  inputs,
  pkgs,
  config,
  nixpkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./dotfiles.nix
    ./emoji.nix
    ./fastfetch
    ./git.nix
    ./grim.nix
    ./gtk.nix
    ./htop.nix
    #    ./hyprland
    ./ghostty.nix
    ./packages.nix
    ./rofi
    ./qt.nix
    ./scripts
    ./stylix.nix
    ./swappy.nix
    ./vscodium.nix
    ./wlogout
    ./xdg.nix
    #    ./zen-browser.nix
    ./zsh
  ];
}
