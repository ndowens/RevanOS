{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    qemu
    libvirt
  ];
  virtualisation.libvirtd.enable = true;
}
