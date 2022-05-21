{ config, lib, pkgs, ... }:

{
  hardware.opengl.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
  };

  programs = {
    sway = {                              # Tiling Wayland compositor & window manager
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        autotiling      # Tiling Script
        swaylock
        mako
        swayidle        # Idle Management Daemon
        wev             # Input viewer
        wl-clipboard    # Commandline Clipboard #alternative clipman/wayclip
        wofi
        #kanshi         # Autorandr #not needed with single laptopscreen. need to find something like arandr
      ];
    };
  };

  sound.enable = true;                    # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
