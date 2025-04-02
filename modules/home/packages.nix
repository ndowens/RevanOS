{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    easyrpg-player
  ];
}
