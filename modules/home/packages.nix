{pkgs, home-manager, ...}:
home.packages = with pkgs; [
  inputs.zen-browser.packages."${system}".default;
  inputs.nixos-updatechecker.nixosModules.nixos-updatechecker;
];
