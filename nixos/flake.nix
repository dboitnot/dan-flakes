{
  description = "Dan's NixOS Configuraiton";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    neovim-flake.url = "github:jordanisaacs/neovim-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.dent = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          { _module.args = { inherit inputs; }; }
        ];
      };
    };
}
