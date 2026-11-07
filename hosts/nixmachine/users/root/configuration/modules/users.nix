{ pkgs, ... }:
{
  users.users.alek = {
    isNormalUser = true;
    description = "Work Profile";

    extraGroups = [ "networkmanager" "wheel" "adbusers" ];

    shell = pkgs.zsh;
  };

  users.users.procrastinator = {
    isNormalUser = true;
    description = "Chill Profile";

    extraGroups = [ "networkmanager" "wheel" "video" "audio" "render" "gamemode" ];

    shell = pkgs.zsh;
  };
}
