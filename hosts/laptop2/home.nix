{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    outputs.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  programs.git.userName = "yurii";
  programs.git.userEmail = "yurii@goxore.com";

  home.persistence."/persist/home" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Documents"
      "Videos"
      "VirtualBox VMs"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".config/dconf"
      ".local/share/keyrings"
      ".local/share/direnv"

      ".mozilla"
      ".cache/mozilla"

      ".local/share/TelegramDesktop"
      ".local/share/nvim"

      ".local/share/Steam"

      ".config/VencordDesktop"

      "nixconf"

    ];
    allowOther = true;
  };

  myHomeManager = {
    bundles.general.enable = true;
    bundles.desktop.enable = true;
    bundles.gaming.enable = true;

    firefox.enable = true;
    hyprland.enable = true;
    pipewire.enable = true;

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 144.003006;
        x = 760;
        y = 1440;
      }
      # {
      #   name = "eDP-2";
      #   width = 1920;
      #   height = 1080;
      #   refreshRate = 144;
      #   x = 760;
      #   y = 1440;
      # }
      # {
      #   name = "HDMI-A-1";
      #   width = 3440;
      #   height = 1440;
      #   refreshRate = 100;
      #   x = 0;
      #   y = 0;
      # }
      {
        name = "DP-2";
        width = 3440;
        height = 1440;
        refreshRate = 144.001007;
        x = 0;
        y = 0;
      }
    ];
  };

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  wayland.windowManager.hyprland.settings.master.orientation = "center";

  home = {
    username = "yurii";
    homeDirectory = lib.mkDefault "/home/yurii";
    stateVersion = "22.11";

    packages = with pkgs; [
      obs-studio
      wf-recorder
      # blender
      prismlauncher
    ];
  };
}
