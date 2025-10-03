{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan.cat9;
in
{
  options.programs.arcan.cat9 = {
    enable = lib.mkEnableOption "Cat9";
    package = lib.mkPackageOption pkgs "cat9" { };
  };
  config.programs.arcan.appls = lib.mkIf cfg.enable [ cfg.package ];
}
