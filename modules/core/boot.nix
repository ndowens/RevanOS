{
  pkgs,
  config,
  inputs,
  ...
}:
let
  #  pkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "amdgpu" ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
  };
}
