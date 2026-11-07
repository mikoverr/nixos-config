{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./modules/hardware.nix
    ./modules/zram-swap.nix
    ./modules/boot.nix
    ./modules/host.nix
    ./modules/users.nix
    ./modules/services.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/locate.nix
    ./modules/fonts.nix
    ./modules/environment.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
