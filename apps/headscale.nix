{ pkgs, lib, config, ... }:
{
  environment.systemPackages = with pkgs; [
    headscale
  ];

  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://hs.oau.app";
      dns = {
        magic_dns = false;
        override_local_dns = false;
      };
    };
    address = "0.0.0.0";
    port = 40180;
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      headscale-ui.settings.services.headscale-ui.service = {
        image = "ghcr.io/gurucomputing/headscale-ui:latest";
        restart = "unless-stopped";
        ports = [ "9443:443" "9090:80" ];
      };
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      hs.oau.app {
        reverse_proxy /web* localhost:9090
        reverse_proxy * localhost:40180
      }
    '';
  };
}
