{ pkgs, ... }:
let
  # Prismlauncher Cracked release
  prismlauncherCracked = pkgs.appimageTools.wrapType2 {
    pname = "prismlauncher-cracked";
    version = "11.1.1";
    src = pkgs.fetchurl {
      url = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/download/11.1.1/PrismLauncher-Linux-x86_64.AppImage";
      hash = "sha256-ZT4FI4uTt4Tz67dmxco0ihAKnWwlZDVoTxQS6wspLHw=";
    };
    # extraPkgs = pkgs: with pkgs; [ libx11 libxext ];
  };

  # fix icon
  prismlauncherIcon = "${prismlauncherCracked}/share/icons/hicolor/256x256/apps/prismlauncher.png";
in
{
  home.packages = with pkgs; [
    # i wonna learn how to make music, but that's later
    # zrythm
    # ardour
    # vital
    # surge-xt

    # chat with ur friends
    vesktop

    # steam tools
    mangohud
    goverlay
    protonup-qt

    # play in your minecraft free (сам бинарник)
    prismlauncherCracked

    # .desktop file for prism
    (makeDesktopItem {
      name = "prismlauncher-cracked";
      desktopName = "Prism Launcher (Cracked)";
      exec = "prismlauncher-cracked";
      icon = prismlauncherIcon;
      categories = [ "Game" ];
    })
  ];
}
