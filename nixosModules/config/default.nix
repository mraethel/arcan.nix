{ arcan
, pkgs
, ...
}: let
  arcanPkgs = arcan.legacyPackages.${ pkgs.system };
in {
  programs.arcan = {
    cat9 = {
      enable = true;
      package = arcanPkgs.cat9;
    };
    durden = {
      enable = true;
      package = arcanPkgs.durden;
    };
    enable = true;
    loginShell.enable = true;
    package = arcanPkgs.arcan-wrapped;
  };
}
