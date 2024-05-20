{ config, lib, pkgs, ... }:

{
  networking.hostName = "zaphod";
  virtualisation.oci-containers.containers.jellyfin = {
    autoStart = true;
    image = "jellyfin/jellyfin:10.9.1";
    ports = [ "8096:8096" ];
    user = "1000:1000";
    volumes = [
        "/home/dboitnot/custom/jellyfin/config:/config"
        "/home/dboitnot/custom/jellyfin/cache:/cache"
        "/mnt/video:/media"
    ];
  };
}
