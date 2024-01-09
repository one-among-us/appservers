{ config, pkgs, ... }:

{
  programs.fish.enable = true;
  users.users = {
    shu = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      homeMode = "755";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtqhzrEH5VnSSxcLn7MJKbCw7QFhQmX8hkSmsEMq8/I shu@iwkr"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQOJJrevWnZsc6KAeQFFRDy7Seun+50d/tjAMLpVlvV shu@wlsn"
      ];
    };
    kuniklo = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      homeMode = "755";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbKzssJYRhfIGqipJd96agUmLs6SkCcIMzGk0dU3B7b openpgp:0x12F68067"
      ];
    };
  };
  nix.settings.trusted-users = [ "@wheel" ];
}
