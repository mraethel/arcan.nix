{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan;
in
{
  options = {
    programs.arcan = {
      enable = lib.mkEnableOption "Arcan";
      package = lib.mkPackageOption pkgs "arcan-wrapped" { };
      appls = lib.mkOption {
        default = [ ];
        type = with lib.types; listOf package;
      };
      loginShell = {
        enable = lib.mkEnableOption "loginShell";
        tty = lib.mkOption {
          default = 1;
          type = lib.types.ints.between 1 10;
        };
        appl = lib.mkOption {
          default = "durden";
          type = lib.types.str;
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      loginShellInit = lib.mkIf cfg.loginShell.enable ''
        if [[ -z $ARCAN_APPLBASEPATH && XDG_VTNR -eq ${builtins.toString cfg.loginShell.tty} ]]; then
          exec arcan ${cfg.loginShell.appl}
        fi
      '';
      systemPackages = [ (cfg.package.override { inherit (cfg) appls; }) ];
    };
    hardware.graphics.enable = true;
  };
}
