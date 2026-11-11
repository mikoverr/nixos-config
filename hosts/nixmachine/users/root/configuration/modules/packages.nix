{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # you need it
    file
    which
    tree
    ripgrep

    # all archives (you like it)
    zip
    unzip
    xz
    p7zip
    unar
    gzip
    bzip2

    # dev (must to be in root)
    mesa # for OpenGL
    android-tools
    go
    cmake
    gcc
    gdb
    gnumake
    libGL
    libGL.dev
    libglvnd
    libglvnd.dev
    ninja
    pkg-config
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
    qt6.wrapQtAppsHook
    jdk8
    jdk17
    jdk21
    (python3.withPackages (ps: with ps; [
      jupyter
      matplotlib
      numpy
      scipy
      yfinance
    ]))

    # usualy needed to run appimage
    libx11
    libxext

    # audio tools (must to be in root)
    easyeffects
    qpwgraph

    # easyeffects plugins
    lsp-plugins
    rnnoise
    rubberband
    calf

    # device tools (i need it)
    piper # frontend for ratbagd

    # zram swap (idk if it works)
    zstd
  ];
}
