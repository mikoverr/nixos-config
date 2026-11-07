{ ... }:

{
  imports = [
    ./modules/services.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/appearance.nix
    ./modules/xdg.nix
  ];

  home = {
    username = "alek";
    homeDirectory = "/home/alek";
    extraOutputsToInstall = [ "dev" ];

    sessionVariables = {
      TZ = "Europe/Moscow";
      XCURSOR_THEME = "material_light_cursors";
      XCURSOR_SIZE = "24";
      # Force Wayland for Qt and Electron apps
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };

  home.stateVersion = "26.05";
}
