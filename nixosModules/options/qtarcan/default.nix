{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.arcan.qtarcan;
in {
  options.programs.arcan.qtarcan = {
    enable = lib.mkEnableOption "QTArcan";
    package = lib.mkPackageOption pkgs "qtarcan6-run" { };
  };
  config.environment.systemPackages = lib.mkIf cfg.enable [ cfg.package ];
}
