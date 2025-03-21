{pkgs, ...}: {
  hardware = {
    sane = {
      enable = true;
      extraBackends = [];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  local.hardware-clock.enable = false;
}
