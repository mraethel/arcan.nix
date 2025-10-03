{
  inputs = {
    arcanNeovim = {
      url = "github:letoram/nvim-arcan";
      flake = false;
    };
    flakeUtils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
  };
  outputs =
    {
      arcanNeovim,
      flakeUtils,
      nixpkgs,
      self,
      ...
    }:
    {
      nixosModules = {
        config.default = import nixosModules/config;
        options = rec {
          arcan = import nixosModules/options/arcan;
          cat9 = import nixosModules/options/cat9;
          default.imports = [
            arcan
            cat9
            durden
            xarcan
          ];
          durden = import nixosModules/options/durden;
          xarcan = import nixosModules/options/xarcan;
        };
      };
      overlays.arcan = import nixpkgsOverlays/arcan self;
      patches.arcan = nixpkgsPatches/arcan/wrapper.diff;
    }
    // flakeUtils.lib.eachDefaultSystem (
      system:
      let
        nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          patches = with self.patches; [ arcan ];
        };
        pkgs = import nixpkgs-patched {
          inherit system;
          overlays = with self.overlays; [ arcan ];
        };
      in
      {
        formatter = pkgs.nixfmt-tree;
        legacyPackages = pkgs;
        packages = {
          nvim-arcan = pkgs.callPackage packages/nvim-arcan { src = arcanNeovim; };
        };
      }
    );
}
