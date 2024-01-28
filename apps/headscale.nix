{ pkgs, lib, config, ... }:
{
  environment.systemPackages = with pkgs; [
    headscale
  ];

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 40180;
    settings.server_url = "https://hs.oau.app";
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      headscale-ui.settings.services.headscale-ui.service = {
        image = "ghcr.io/gurucomputing/headscale-ui:latest";
        restart = "unless-stopped";
        ports = [ "9443:443" ];
      };
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      hs.oau.app {
        reverse_proxy /web* https://localhost:9443 {
          transport http {
            tls_insecure_skip_verify
          }
        }
        reverse_proxy * localhost:40180
      }
    '';
  };
}
