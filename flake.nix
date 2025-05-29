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
  { arcanNeovim
  , flakeUtils
  , nixpkgs
  , self
  , ...
  }: {
    overlays.arcan = import nixpkgsOverlays/arcan self;
    patches.arcan = nixpkgsPatches/arcan/wrapper.diff;
  } // flakeUtils.lib.eachDefaultSystem (system: let
    nixpkgs-patched = (import nixpkgs { inherit system; })
      .applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = with self.patches; [ arcan ];
      };
    pkgs = import nixpkgs-patched {
      inherit system;
      overlays = with self.overlays; [ arcan ];
    };
  in {
    legacyPackages = pkgs;
    packages = {
      nvim-arcan = pkgs.callPackage packages/nvim-arcan { src = arcanNeovim; };
    }; 
  });
}
