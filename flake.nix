{
  # description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "nixmachine" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/nixmachine/users/root/configuration/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.backupFileExtension = "hm-backup";

            home-manager.users.alek = import ./hosts/nixmachine/users/alek/home-manager/home.nix;
            home-manager.users.procrastinator = import ./hosts/nixmachine/users/procrastinator/home-manager/home.nix;
          }
        ];
      };

      "server" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/server/users/root/configuration/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.backupFileExtension = "hm-backup";

            home-manager.users.admin = import ./hosts/server/users/admin/home-manager/home.nix;
          }
        ];
      };
    };
  };
}
