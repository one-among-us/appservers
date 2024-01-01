{ config, pkgs, ... }:

{
  programs.fish.enable = true;
  users.users = {
    shu = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "lp" "scanner" ];
      shell = pkgs.fish;
      homeMode = "755";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtqhzrEH5VnSSxcLn7MJKbCw7QFhQmX8hkSmsEMq8/I shu@iwkr"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQOJJrevWnZsc6KAeQFFRDy7Seun+50d/tjAMLpVlvV shu@wlsn"
      ];
    };
  };
  nix.settings.trusted-users = [ "@wheel" ];
}
