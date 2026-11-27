{
  description = "NixOS configurations for laptop (ThinkPad T480s) and pc (Ryzen 7700X / RX 6950 XT)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Every host gets the shared modules plus its own folder.
      # The platform comes from nixpkgs.hostPlatform in hardware-configuration.nix.
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules
            ./hosts/${hostName}
            { networking.hostName = hostName; }
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [
        "laptop"
        "pc"
      ] mkHost;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
