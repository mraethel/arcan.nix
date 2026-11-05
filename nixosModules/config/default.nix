{
  arcan,
  pkgs,
  qtarcan,
  ...
}:
let
  arcanPkgs = arcan.legacyPackages.${pkgs.system};
  qtarcanPkgs = qtarcan.legacyPackages.${pkgs.system};
in
{
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
    package = arcanPkgs.arcan;
    qtarcan = {
      enable = true;
      package = qtarcanPkgs.qtarcan6-run;
    };
    xarcan = {
      enable = true;
      package = arcanPkgs.xarcan;
    };
  };
}
