{ pkgs, ... }:
{
  programs = {
    # hyprland in every home!
    hyprland.enable = true;

    # it doesnt matter what it is
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        openssl
        zlib
        glibc
        curl
      ];
    };

    # everyone should have zsh
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true; # the community can't decide how to sound right, LoL ;>
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" "docker" ];
      };

      shellAliases = {
        vi = "nvim";
        gonix = "/etc/nixos/gonix.sh";
      };
    };

    # regular developer stuff
    git.enable = true;
    neovim.enable = true;

    # he's with me forever
    firefox.enable = true;

    # useful programs that work for all users of this system
    localsend.enable = true;
    clash-verge = {
      enable = true;
      serviceMode = true;
      tunMode = true;
    };

    # i love games
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    # some speed up
    gamemode.enable = true;
  };
}
