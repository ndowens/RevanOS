{
  ...
}:
{
  environment.variables.AMD_VULKAN_ICD = "RADV";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  imports = [
    ./amd-drivers.nix
    ./local-hardware-clock.nix
    ./vm-guest-services.nix
  ];
}
