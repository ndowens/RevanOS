{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    vscodium
    direnv.out
  ];
}
