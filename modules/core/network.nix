{
  pkgs,
  host,
  options,
  ...
}: {
  systemd.network = {
    enable = true;
    networks."10-lan" = {
      matchConfig.Name = "enp*";
      networkConfig.DHCP = "ipv4";
    };
  };

  networking = {
    useNetworkd = true;
    hostName = "Revan";
    networkmanager.enable = false;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
