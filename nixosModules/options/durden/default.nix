{ config
, lib 
, pkgs
, ...
}: let 
  cfg = config.programs.arcan.durden;
in {
  options.programs.arcan.durden = {
    config = lib.mkOption {
      default = { };
      type = lib.types.attrs;
    };
    enable = lib.mkEnableOption "Durden";
    package = lib.mkPackageOption pkgs "durden" {};
  };
  config.programs.arcan.appls = lib.mkIf cfg.enable [ cfg.package ];
}
