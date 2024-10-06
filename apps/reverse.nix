{ pkgs, lib, config, ... }:
let
  live-website = ./live-website;
  tia-legacy = ./tia-legacy;
in
{
  services.caddy = {
    enable = true;
    extraConfig = ''
      live.oau.app {
        tls info@oneamongus.ca
        root * ${live-website}
        file_server
        handle_errors {
          redir * /
          file_server
        }
      }

      oau.edu.kg {
        tls info@oneamongus.ca
        root * ${tia-legacy}
        file_server
        handle_errors {
          redir * /
          file_server
        }
      }

      lib.oau.edu.kg {
        tls info@oneamongus.ca
        root * ${tia-legacy}
        file_server
        handle_errors {
          redir * /
          file_server
        }
      }
    '';
  };
}
