{ host, ... }:
{
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = true;
  vm.guest-services.enable = false;

  # Enable tailscale
  services.tailscale.enable = true;
}
