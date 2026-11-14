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
        header >last-modified "Tue, 26 Nov 2024 12:45:00 GMT"
      }

      oau.edu.kg {
        tls info@oneamongus.ca
        root * ${tia-legacy}
        file_server
        handle_errors {
          redir * /
          file_server
        }
        header >last-modified "Tue, 26 Nov 2024 12:45:00 GMT"
      }

      lib.oau.edu.kg {
        tls info@oneamongus.ca
        root * ${tia-legacy}
        file_server
        handle_errors {
          redir * /
          file_server
        }
        header >last-modified "Tue, 26 Nov 2024 12:45:00 GMT"
      }

      api.oau.app {
        @supabase path /auth/v1/* /rest/v1/* /realtime/v1/* /functions/v1/*
        handle @supabase {
          reverse_proxy 127.0.0.1:8000
        }
        handle {
          respond 404
        }
      }
    '';
  };
}
