{ ... }:
{
  services.oau-payment-backend = {
    enable = true;
    environmentFile = "/var/lib/secrets/payment-backend.env";
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      donate.oau.app {
        reverse_proxy 127.0.0.1:3000
      }
    '';
  };
}
