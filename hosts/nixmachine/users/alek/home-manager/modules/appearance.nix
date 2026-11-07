{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${pkgs.graphite-gtk-theme}/share/themes/Graphite-Dark/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${pkgs.graphite-gtk-theme}/share/themes/Graphite-Dark/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${pkgs.graphite-gtk-theme}/share/themes/Graphite-Dark/gtk-4.0/gtk-dark.css";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Graphite-Dark";
      icon-theme = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.pointerCursor = {
    package = pkgs.material-cursors;
    name = "material_light_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
