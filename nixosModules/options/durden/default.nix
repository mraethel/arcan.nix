{ config
, lib 
, pkgs
, ...
}: let 
  cfg = config.programs.arcan.durden;
in {
  options.programs.arcan.durden = {
    enable = lib.mkEnableOption "Durden";
    package = lib.mkPackageOption pkgs "durden" {};
  };
  config.programs.arcan.appls = lib.mkIf cfg.enable [ cfg.package ];
}
