{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = false;
    podman.enable = true;
  };
  programs = {
    virt-manager.enable = false;
  };
  environment.systemPackages = with pkgs; [
    # virt-viewer # View Virtual Machines
    virtualbox
  ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["ndowens"];
}
