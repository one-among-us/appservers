# Appservers

## Update Server
```
nixos-rebuild switch --flake path:.#<hostname> --target-host <hostname> --sudo 
```

## Declare Your Privilege
Create your account to servers by adding user configuration (incl. ssh keys) to `./user.nix`. It requires a rebuild to take effect.

## Auto Update
Not implemented and not planned yet.

## Payment backend

The `payment-backend` flake input provides its own package and NixOS service
module. This repository enables that module and explicitly configures the Caddy
reverse proxy in `apps/payment-backend.nix`; the service runs as a hardened
dynamic systemd user and is served at `donate.oau.app`.

Before the first rebuild, create its root-only environment file on the target:

```sh
sudo install -d -m 0700 /var/lib/secrets
sudo install -m 0600 /dev/null /var/lib/secrets/payment-backend.env
sudoedit /var/lib/secrets/payment-backend.env
```

The file must contain:

```dotenv
STRIPE_SECRET_KEY=sk_live_replace_me
# Optional: STRIPE_WEBHOOK_SECRET=whsec_replace_me
TURNSTILE_SECRET_KEY=replace_me
TURNSTILE_HOSTNAMES=www.oneamongus.ca,oneamongus.ca
ALLOWED_ORIGINS=https://www.oneamongus.ca,https://oneamongus.ca
DONATION_MIN_CAD=5
DONATION_MAX_CAD=2000
SUCCESS_URL=https://www.oneamongus.ca/donate/success
CANCEL_URL=https://www.oneamongus.ca/contact
ZH_HANS_SUCCESS_URL=https://www.oneamongus.ca/zh-Hans/donate/success
ZH_HANS_CANCEL_URL=https://www.oneamongus.ca/zh-Hans/contact
TRUST_PROXY=true
```

Commit and push `payment-backend` before updating this flake input. Then run:

```sh
nix flake lock --update-input payment-backend
sudo nixos-rebuild switch --flake path:.#ctvp
systemctl status payment-backend
curl --fail https://donate.oau.app/healthz
```
