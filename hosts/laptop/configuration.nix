{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  system,
  myLib,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      # (import ./disko.nix {device = "/dev/nvme1n1";})
      (import ./disko.nix {device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S736NU0W100374K";})

      inputs.disko.nixosModules.default

      ./experimental/experimental.nix
    ]
    ++ (myLib.filesIn ./included);
  programs.corectrl.enable = true;

  boot = {
    loader.grub.enable = true;
    loader.grub.efiSupport = true;
    loader.grub.efiInstallAsRemovable = true;

    supportedFilesystems.ntfs = true;

    kernelParams = ["quiet"];
    kernelModules = ["coretemp" "cpuid" "v4l2loopback"];
  };

  boot.plymouth.enable = true;

  services.xserver.videoDrivers = ["amdgpu"];
  boot.initrd.kernelModules = ["amdgpu"];

  myNixOS = {
    bundles.general-desktop.enable = true;
    hyprland.enable = true;
    power-management.enable = true;

    virtualisation.enable = lib.mkDefaut true;

    bundles.users.enable = true;
    home-users = {
      "yurii" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = ["networkmanager" "wheel" "libvirtd" "docker" "adbusers" "openrazer"];
        };
      };
    };

    impermanence.enable = true;
    impermanence.nukeRoot.enable = true;
  };
  users.users.yurii.hashedPasswordFile = "/persist/passwd";

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  hardware.openrazer.enable = true;

  services = {
    hardware.openrgb.enable = true;
    flatpak.enable = true;
    udisks2.enable = true;
    printing.enable = true;
  };

  programs.zsh.enable = true;
  programs.adb.enable = true;

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
    glib
  ];

  system.stateVersion = "23.11";
}
