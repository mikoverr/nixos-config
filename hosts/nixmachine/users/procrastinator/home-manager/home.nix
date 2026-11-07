{ ... }:
{
  imports = [
    ./modules/programs.nix
    ./modules/packages.nix
  ];

  home = {
    username = "procrastinator";
    homeDirectory = "/home/procrastinator";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };
  };

  home.stateVersion = "26.05";
}
