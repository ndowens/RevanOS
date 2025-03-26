{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [guix];
}
