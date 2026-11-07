{ ... }:
{
  services = {
    # the x11 config that only dm needsneeded for DM
    xserver = {
      enable = true;

      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
      };
    };

    # it's minimalistic, it looks cool, and I like it
    displayManager.ly = {
      enable = true;

      settings = {
        animation = "matrix";
        bigclock = "en";
        bigclock_seconds = true;

        bg = "0x00202020";
        fg = "0x00e0e0e0";
        border_fg = "0x003c3c3c";

        error_bg = "0x00202020";
        error_fg = "0x01f28b82";

        cmatrix_fg = "0x008ab4f8";
        cmatrix_head_col = "0x01ffffff";
      };
    };

    # do you listen to breakcore?
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig.pipewire."99-lowlatency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
    };

    # he's so dear
    desktopManager.plasma6.enable = true;

    # useful file manager extensions
    udisks2.enable = true;
    gvfs.enable = true;

    # a dbms that just works
    postgresql.enable = true;

    # daemon for my logitech g304
    ratbagd.enable = true;
  };

  # prioritizing sound
  security.rtkit.enable = true;
}
