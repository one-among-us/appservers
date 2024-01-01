{ modulesPath, ... }:
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

}
