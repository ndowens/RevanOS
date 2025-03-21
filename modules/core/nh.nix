{
  pkgs,
  username,
  ...
}: let
  username = "ndowens";
in {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/${username}/.config/home-manager";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
