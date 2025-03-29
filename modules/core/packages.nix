{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    firefox.enable = false; # Firefox is not installed by default
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = false;
    nix-index.enable = true;
    command-not-found.enable = false;
    zsh.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alejandra
    brightnessctl # For Screen Brightness Control
    clang
    distrobox
    duf # Utility For Viewing Disk Usage In Terminal
    eza # Beautiful ls Replacement
    file-roller # Archive Manager
    gamemode
    gedit # Simple Graphical Text Editor
    greetd.tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    htop # Simple Terminal Based System Monitor
    hyprpicker # Color Picker
    eog # For Image Viewing
    inxi # CLI System Information Tool
    kdePackages.konversation
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt-rfc-style # Nix Formatter
    nwg-displays #configure monitor configs via GUI
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    power-profiles-daemon
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
  ];
}
