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
    homeManager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    qtarcan.url = "git+https://codeberg.org/vimpostor/qtarcan";
    systems.url = "github:nix-systems/default-linux";
    xkb2kbdlua = {
      flake = false;
      url = "git+https://codeberg.org/btrach/xkb2kbdlua";
    };
  };
  outputs =
    inputs@{
      flakeUtils,
      homeManager,
      nixpkgs,
      qtarcan,
      self,
      ...
    }:
    rec {
      homeModules.options.default = import homeModules/options;
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = inputs // {
          arcan = self;
          localLib = nixosLibrary.default;
        };
        modules =
          (with nixosModules; [
            config.default
            config.image
            options.default
          ])
          ++ [ homeManager.nixosModules.home-manager ];
      };
      nixosLibrary.default = import ./nixosLibrary;
      nixosModules = {
        config = {
          default = import nixosModules/config;
          image = import nixosModules/config/image.nix;
        };
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
      overlays = {
        arcan = import nixpkgsOverlays/arcan self;
        qutebrowser = import nixpkgsOverlays/qutebrowser;
      };
      patches.arcan.package = nixpkgsPatches/arcan/package.diff;
    }
    // flakeUtils.lib.eachDefaultSystem (
      system:
      let
        nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          patches = with self.patches.arcan; [ package ];
        };
        pkgs = import nixpkgs-patched {
          inherit system;
          overlays = with self.overlays; [ arcan ];
        };
        qtpkgs = qtarcan.legacyPackages.${system}.extend self.overlays.qutebrowser;
      in
      {
        formatter = pkgs.nixfmt-tree;
        legacyPackages = pkgs;
        packages = {
          inherit (qtpkgs) qutebrowser;
          nvim-arcan = pkgs.callPackage packages/nvim-arcan { src = inputs.arcanNeovim; };
          xkb2kbdlua = pkgs.callPackage packages/xkb2kbdlua { src = inputs.xkb2kbdlua; };
        };
      }
    );
}
