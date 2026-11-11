{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./modules/hardware.nix
    ./modules/zram-swap.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/home-manager.nix
    ./modules/services.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/locale.nix
    ./modules/fonts.nix
    ./modules/environment.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
