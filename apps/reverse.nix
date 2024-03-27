{ pkgs, lib, config, ... }:
let
  live-website = ./live-website;
in
{
  services.caddy = {
    enable = true;
    extraConfig = ''
      transacademic.org {
        reverse_proxy * https://oau.edu.kg {
          header_up Host {http.reverse_proxy.upstream.hostport}
        }
      }

      http://live.oau.app {
        redir https://example.com{url}
      }
      https://live.oau.app {
        tls info@oneamongus.ca
        root * ${live-website}
        header / {
          Content-Security-Policy = "upgrade-insecure-requests; default-src 'self'; style-src 'self'; script-src 'self'; img-src 'self'; object-src 'self'; worker-src 'self'; manifest-src 'self';"
          Strict-Transport-Security = "max-age=63072000; includeSubDomains; preload"
          X-Xss-Protection = "1; mode=block"
          X-Frame-Options = "DENY"
          X-Content-Type-Options = "nosniff"
          Referrer-Policy = "strict-origin-when-cross-origin"
          Permissions-Policy = "fullscreen=(self)"
          cache-control = "max-age=0,no-cache,no-store,must-revalidate"
        }
        handle_errors {
          @404 {
            expression {http.error.status_code}==404
          }
          rewrite @404 /index.html
        }
      }
    '';
  };
}
