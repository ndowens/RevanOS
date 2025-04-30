{
  services.desktopManager = {
    cosmic.enable = true;
    plasma6.enable = false;
  };
  services.displayManager = {
    sddm.wayland.enable = false;
    cosmic-greeter.enable = true;
  };
  services.xserver.displayManager = {
    gdm.wayland = false;
    gdm.enable = false;
  };
}
