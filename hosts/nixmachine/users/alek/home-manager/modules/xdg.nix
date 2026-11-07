{ ... }:
{
  xdg = {
    enable = true;

    mime.enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        # Default File manager
        "inode/directory" = [ "yazi.desktop" ];

        # Text
        "text/plain" = [ "dev.zed.Zed.desktop" ];
        "text/x-csrc" = [ "dev.zed.Zed.desktop" ];

        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];

        # Video
        "video/mp4" = [ "mpv.desktop" ];

        # Web and PDF
        "text/html" = [ "firefox.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    };
  };
}
