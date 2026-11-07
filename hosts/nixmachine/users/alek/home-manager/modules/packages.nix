{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # awesome shell
    quickshell

    # hypr delete (replace to qs or tui)
    waybar
    rofi
    dunst
    hyprpaper
    hypridle
    hyprlock
    wlogout
    kdePackages.dolphin
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.kio-extras

    # hypr apps
    kitty
    imv
    mpv

    # hypr common utils (maybe u need it in the configs)
    kdePackages.polkit-kde-agent-1
    brightnessctl
    playerctl
    networkmanagerapplet
    blueman
    pavucontrol
    gsettings-desktop-schemas
    grim
    slurp
    wl-clipboard
    wl-clip-persist
    cliphist

    # not really needed
    fastfetch
    cowsay

    # tui is awesome
    yazi
    btop

    # other useful cli
    scrcpy
    aider-chat

    # dev apps
    zed-editor
    android-studio
    qtcreator
    dbeaver-bin
    obsidian

    # office apps
    onlyoffice-desktopeditors
  ];
}
