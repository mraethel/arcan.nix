{
  inputs = {
    arcanNeovim = {
      flake = false;
      url = "github:letoram/nvim-arcan";
    };
    flakeUtils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    xkb2kbdlua = {
      flake = false;
      url = "git+https://codeberg.org/btrach/xkb2kbdlua";
    };
  };
  outputs =
    inputs@{
      flakeUtils,
      nixpkgs,
      self,
      ...
    }:
    {
      homeModules.options.default = import homeModules/options;
      nixosModules = {
        config.default = import nixosModules/config;
        options = rec {
          arcan = import nixosModules/options/arcan;
          cat9 = import nixosModules/options/cat9;
          default.imports = [
            arcan
            cat9
            durden
            home
            xarcan
          ];
          durden = import nixosModules/options/durden;
          home = import nixosModules/options/home;
          xarcan = import nixosModules/options/xarcan;
        };
      };
      overlays.arcan = import nixpkgsOverlays/arcan self;
      patches.arcan = {
        package = nixpkgsPatches/arcan/package.diff;
        wrapper = nixpkgsPatches/arcan/wrapper.diff;
      };
    }
    // flakeUtils.lib.eachDefaultSystem (
      system:
      let
        nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          patches = with self.patches.arcan; [
            package
            wrapper
          ];
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
          nvim-arcan = pkgs.callPackage packages/nvim-arcan { src = inputs.arcanNeovim; };
          xkb2kbdlua = pkgs.callPackage packages/xkb2kbdlua { src = inputs.xkb2kbdlua; };
        };
      }
    );
}
