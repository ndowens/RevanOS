{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center
  ];
}
