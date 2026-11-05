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
      config = {
        hide_titlebar = true;
        sbar_alpha = 1;
        sbar_autohide = 1;
        titlebar_statusbar = true;
      };
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
