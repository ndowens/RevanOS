{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    firefox.enable = false; # Firefox is not installed by default
    nm-applet = {
      enable = false;
      indicator = false;
    };
    dconf.enable = true;
    hyprland.enable = true;
    seahorse.enable = false;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = false;
    nix-index.enable = true;
    command-not-found.enable = false;
    zsh.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
    nix-ld.enable = true;
    gnupg.agent = {
      enable = false;
      enableSSHSupport = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alejandra
    brightnessctl # For Screen Brightness Control
    distrobox
    duf # Utility For Viewing Disk Usage In Terminal
    eza # Beautiful ls Replacement
    file-roller # Archive Manager
    fzf
    gamemode
    gedit # Simple Graphical Text Editor
    greetd.tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    htop # Simple Terminal Based System Monitor
    hyprpicker # Color Picker
    eog # For Image Viewing
    inxi # CLI System Information Tool
    kdePackages.konversation
    killall # For Killing All Instances Of Programs
    latencyflex-vulkan
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt-rfc-style # Nix Formatter
    nix-output-monitor
    nwg-displays # configure monitor configs via GUI
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    playerctl # Allows Changing Media Volume Through Scripts
    power-profiles-daemon
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
    wineWowPackages.staging
    wineWowPackages.waylandFull
    inputs.nix-search-tv.packages.x86_64-linux.default
  ];
}
