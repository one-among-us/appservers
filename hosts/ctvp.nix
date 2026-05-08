{ modulesPath, pkgs, ... }:
{
  system.stateVersion = "24.05";
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda3"; fsType = "ext4"; };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  security.sudo.wheelNeedsPassword = false;
  networking.firewall.enable = false;

  boot.extraModprobeConfig = ''
    # Mitigate CVE-2026-43284 CVE-2026-43500 https://dirtyfrag.io
    # https://github.com/V4bel/dirtyfrag
    install esp4 ${pkgs.coreutils}/bin/false
    install esp6 ${pkgs.coreutils}/bin/false
    install rxrpc ${pkgs.coreutils}/bin/false

    # Mitigate CVE-2026-31431 https://copy.fail
    # https://github.com/theori-io/copy-fail-CVE-2026-31431
    install algif_aead ${pkgs.coreutils}/bin/false
  '';
}
