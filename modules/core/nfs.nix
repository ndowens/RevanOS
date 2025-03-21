{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) enableNFS;
in {
  services = {
  };
}
