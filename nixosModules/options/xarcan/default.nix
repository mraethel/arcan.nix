{ config
, lib
, pkgs
, ...
}: let
  cfg = config.programs.arcan.xarcan;
in {
  options.programs.arcan.xarcan = {
    enable = lib.mkEnableOption "Xarcan";
    package = lib.mkPackageOption pkgs "xarcan" {};
    #
    # For using wmaker this would be great.
    #
    # autoStart = {
    #   enable  = lib.mkEnableOption "autoStart";
    #   workspace = lib.mkOption {
    #     default = 1;
    #     type = lib.types.ints.beetween 1 10;
    #   };
    # };
  };
  config.environment.systemPackages = lib.mkIf cfg.enable [ cfg.package ];
}
