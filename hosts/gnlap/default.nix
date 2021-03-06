{ config, pkgs, lib, user, ... }:
let
  host = "gnlap";

in
{
  imports = # For now, if applying to other system, swap files
    [
      (import ./hardware-configuration.nix) # Current system hardware config @ /etc/nixos/hardware-configuration.nix
      (import ../../modules/gnlap/qtile/qtile.nix)
      (import ../../modules/gnlap/sway/sway.nix)
    ]; # Window Manager

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    # initrd.kernelModules = [ "amdgpu" ];        # Video drivers

    loader = {
      # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 1; # Grub auto select time
    };
  };
  networking.hostName = "gnlap"; # Define your hostname.

  users.users.${user} = {
    # set gnlap specific groups
    extraGroups = [
      "audio"
      "camera"
      "docker"
      "kvm"
      "libvirtd"
      "lp"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  environment = {
    # Packages installed system wide
    systemPackages = with pkgs; [
      # This is because some options need to be configured.
      x11vnc
      wacomtablet
      appimage-run
    ];
  };

  services = {
    blueman.enable = true; # Bluetooth
    printing = {
      # Printing and drivers for TS5300
      enable = true;
      drivers = [ pkgs.cnijfilter2 ]; # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now.
    };
    avahi = {
      # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {
        # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    xserver = {
      # In case, multi monitor support
      enable = true;
      videoDrivers = [
        # Video Settings
        "intelgpu"
      ];

      modules = [ pkgs.xf86_input_wacom ]; # Both needed for wacom tablet usage
      wacom.enable = true;
    };
  };
}
