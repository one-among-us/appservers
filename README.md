# Appservers

## Update Server
```
nixos-rebuild switch --flake path:.#<hostname> --target-host <hostname> --use-remote-sudo 
```

## Declare Your Privilege
Create your account to servers by adding user configuration (incl. ssh keys) to `./user.nix`. It requires a rebuild to take effect.

## Auto Update
Not implemented and not planned yet.
