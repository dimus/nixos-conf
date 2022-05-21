# Enable Qtile
{
  services.xserver = {
    windowManager.qtile.enable = true;
    displayManager = {
      sddm.enable = true;
      session = [
      {
        manage = "desktop";
        name = "xsession";
        start = "source $HOME/.xsession";
      }
      ];
    };
  };
  programs.nm-applet.enable = true;
}
