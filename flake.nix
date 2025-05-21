{
  inputs = {
    flakeUtils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
  };
  outputs =
  { flakeUtils
  , nixpkgs
  , self
  , ...
  }: {
    overlays.arcan = import nixpkgsOverlays/arcan;
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
  in { packages = pkgs; });
}
