{ ... }: {
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/security.nix
    ./modules/zram-swap.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/services.nix
    ./modules/packages.nix
    ./modules/virtualisation.nix
    ./modules/locale.nix
  ];

  system.stateVersion = "26.05";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true; # deduplication of files in /nix/store (saves space)
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Automatic system update
  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false; # manual reboots
  # };
}
