{ config, pkgs, lib, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim # emacs
    wget git
    fd ripgrep lsof eza
    fish
    htop iotop iftop procs
  ];

  programs.command-not-found.enable = lib.mkDefault false;

  services.openssh.enable = true;
  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ ];
  # };
  programs.ssh = {
    extraConfig = ''
      Host *
          PubkeyAcceptedAlgorithms +ssh-rsa
          HostkeyAlgorithms +ssh-rsa
    '';
  };
  services.tailscale.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
      download-attempts = 5
      connect-timeout = 15
      stalled-download-timeout = 10
    '';

    registry = {
      nixpkgs = {
        from = { id = "nixpkgs"; type = "indirect"; };
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];

    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "Sun 01:00";
    };
  };

}
