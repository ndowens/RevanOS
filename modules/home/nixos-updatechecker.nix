{
  service.nixos-updatechecker = {
    enabled = true;
    always-active = false;
    preview-command = "kitty -e bash -c \"cat {} && read\"";
    recheck-interval = 3600 * 12;
    icon-no-updates = "software-updates-inactive";
    icon-updates = "software-updates-updates";
    icon-pending = "task-recurring";
    ignored-pkgs = ["source"];
    update-command = "kitty -e bash -c \"sudo nixos-rebuild switch --flake .#{};read -p 'Press Enter to finish!' </dev/tty\"";
  };
}
