{ pkgs, lib, config, ... }:
{
  services.caddy = {
    enable = true;
    extraConfig = ''
      transacademic.org {
        reverse_proxy * https://oau.edu.kg {
          header_up Host {http.reverse_proxy.upstream.hostport}
        }
      }
    '';
  };
}
