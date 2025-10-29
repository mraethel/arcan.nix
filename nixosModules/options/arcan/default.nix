{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan;
  pkg = cfg.package.override { inherit (cfg) appls; };
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
    # systemd.user.services.arcan = {
    #   enable = cfg.loginShell.enable;
    #   restartIfChanged = false;
    #   script = "${pkg}/bin/arcan durden";
    #   serviceConfig = {
    #     TTYPath = "/dev/tty1";
    #     TTYReset = "yes";
    #     TTYVHangup = "yes";
    #     TTYVTDisallocate = true;
    #     Type = "simple";
    #   };
    #   unitConfig.ConditionUser = "!root";
    #   wantedBy = [ "default.target" ];
    # };
    environment = {
      loginShellInit = lib.mkIf cfg.loginShell.enable ''
        if [[ -z $ARCAN_APPLBASEPATH && $XDG_VTNR -eq ${builtins.toString cfg.loginShell.tty} ]]; then
          export ARCAN_APPLSTOREPATH='.arcan/appl-out'
          export ARCAN_STATEBASEPATH='.arcan/savestates'
          exec arcan ${cfg.loginShell.appl}
        fi
      '';
      systemPackages = [ pkg ];
    };
    hardware.graphics.enable = true;
  };
}
