{ pkgs, lib, config, ... }:
let
  domain = "oau.app";
  baseUrl = "https://${domain}";
  admin_email = "serviceadmin@${domain}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${domain}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.caddy = {
    enable = true;
    extraConfig = ''
      ${domain} {
        header /calendar/ical/* {
          Access-Control-Allow-Origin *
          Access-Control-Allow-Credentials true
          Access-Control-Allow-Methods *
          Access-Control-Allow-Headers *
        }
        reverse_proxy /calendar/ical/* https://calendar.google.com {
          header_up Host {http.reverse_proxy.upstream.hostport}
        }
        reverse_proxy /_matrix/* localhost:8008
        reverse_proxy /_synapse/client/* localhost:8008
        header /.well-known/matrix/* Content-Type application/json
        header /.well-known/matrix/* Access-Control-Allow-Origin *
        respond /.well-known/matrix/server `{"m.server": "${domain}:443"}`
        respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"${domain}"}}`
      }
    '';
  };

  nixpkgs.config.permittedInsecurePackages = lib.singleton "olm-3.2.16";
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = domain;
      serve_server_wellknown = true;
      public_baseurl = baseUrl;
      registration_shared_secret_path = "/var/lib/matrix-synapse/secrets"; # TODO improve
      listeners = lib.singleton {
        port = 8008;
        bind_addresses = [ "::1" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = lib.singleton {
          names = [ "client" "federation" ];
          compress = true;
        };
      };
    };
  };
}
