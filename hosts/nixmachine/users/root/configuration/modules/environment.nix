{ ... }:
{
  environment.loginShellInit = ''
    if [ "$USER" = "alek" ] && [[ "$DESKTOP_SESSION" == *"plasma"* ]]; then
      echo "Alek user is not allowed to log in to KDE"
      exit 1
    fi

    if [ "$USER" != "alek" ] && [[ "$DESKTOP_SESSION" == *"hyprland"* ]]; then
      echo "Access to Hyprland is only allowed for alek's profile"
      exit 1
    fi
  '';

  environment.shellAliases = {
    rebuild = "bash /etc/nixos/rebuild.sh";
  };

  environment.pathsToLink = [ "/include" "/lib/pkgconfig" "/share/pkgconfig" "/lib/cmake" ];
}
