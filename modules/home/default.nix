{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) waybarChoice;
in {
  imports = [
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./dotfiles.nix
    ./emoji.nix
    ./fastfetch
    ./gh.nix
    ./git.nix
    ./gtk.nix
    ./htop.nix
    ./hyprland
    ./kitty.nix
    ./nvf.nix
    ./rofi
    ./qt.nix
    ./scripts
    ./starship.nix
    ./stylix.nix
    ./swappy.nix
    ./swaync.nix
    ./virtmanager.nix
    waybarChoice
    ./wezterm.nix
    ./wlogout
    ./xdg.nix
    ./yazi
    ./zen-browser.nix
    ./zsh
  ];
}
