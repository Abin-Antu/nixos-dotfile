{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 🔁 Kernel switcher
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Examples:
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_lts;
}
