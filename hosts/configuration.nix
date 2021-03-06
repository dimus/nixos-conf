{ config, lib, pkgs, inputs, user, location, ... }:

{
  users.users.${user} = {
    # System User
    isNormalUser = true;
    # extraGroups are set for each machine
    # extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" ];
    shell = pkgs.bash; # Default shell
  };

  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "America/Chicago"; # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus32";
    # keyMap = "us";	                    # or us/azerty/etc
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # fonts must be registered here
  fonts.fonts = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # select specific fonts from nerdfonts
      fonts = [ "FiraCode" "FiraMono" "Go-Mono" "Hack" "JetBrainsMono" ];
    })
  ];

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # Default packages install system-wide
      #internet
      firefox
      brave
      tdesktop # telegram-desktop
      wget

      # documents
      pandoc
      texlive.combined.scheme-full
      zathura
      jq

      # system
      killall
      pciutils
      usbutils
      ansible

      # nix
      nix-index
      comma

      # networking
      networkmanager

      # databases
      postgresql_14

      # reference
      tldr

      # editors
      vim
      helix
      neovim
      tree-sitter
      nodePackages.markdownlint-cli

      # dotfiles
      chezmoi

      # sound
      pavucontrol
      pipewire

      # multimedia
      mpd
      mpc_cli
      mpv
      imv
      zoom-us
      transmission
      transmission-qt

      # window manager
      qtile
      wlroots
      python39Packages.pywlroots
      wlr-randr
      lm_sensors # to get `sensors` to see temperature tags
      dmenu
      nitrogen
      sway
      dunst
      xorg.xkill
      picom
      sxhkd
      flameshot
      blueberry # bluetooth configuration
      xclip # operate system clipboard
      wl-clipboard #wl-copy wl-paste for wayland
      handlr

      # filesystem
      ntfs3g
      ripgrep
      fd
      broot
      du-dust
      rsync
      # snapper

      # art
      blender

      # terminal
      alacritty
      kitty
      tmux
      starship

      # monitoring
      glances
      htop
      btop

      # development
      gnumake
      automake
      git
      go_1_18
      gopls
      rustup
      rust-analyzer
      gcc
      binutils
      rnix-lsp # lsp for nix
      bundix
      python39Packages.pylsp-mypy # lsp for python

      # periferals
      xf86_input_wacom

      # libraries
      zlib
      openssl

      # security
      pass
      keychain
    ];
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services = {
    xserver = {
      desktopManager.plasma5.enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          disableWhileTyping = true;
          tapping = false;
        };
      };
    };
    snapper.configs = {
      home = {
        subvolume = "/home";
        extraConfig = ''
          ALLOW_USERS="dimus"
          TIMELINE_CREATE="yes"
          TIMELINE_CLEANUP="yes"
        '';
      };
    };
    openssh = {
      # SSH
      enable = true;
      allowSFTP = true;
    };
    sshd.enable = true;
    flatpak.enable = true; # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
    # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE dimus WITH LOGIN PASSWORD 'dimus' SUPERUSER;
      CREATE DATABASE dimus;
      GRANT ALL PRIVILEGES ON DATABASE dimus TO dimus;
    '';
  };

  xdg.portal = {
    # Required for flatpak
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  system = {
    # NixOS settings
    autoUpgrade = {
      # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}
