{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan;
  pkg = cfg.package.overrideAttrs (final: prev: {
    passthru = prev.passthru // {
      wrapper = prev.passthru.wrapper.override {
        inherit (cfg) appls;
      };
    };
  });
  wrapper = (pkg.override { storePath = pkg.wrapper; }).wrapper;
  toDB =
    targets:
    lib.strings.concatLines (
      lib.attrsets.mapAttrsToList (
        name: target:
        "arcan_db add_target ${name} ${
          lib.strings.optionalString (target.tag != "") "-"
        }${target.tag} ${target.bfrm} ${target.exec} ${lib.strings.concatStringsSep " " target.argv}"
      ) targets
    );
in
{
  options = {
    programs.arcan = {
      enable = lib.mkEnableOption "Arcan";
      package = lib.mkPackageOption pkgs "arcan" { };
      appls = lib.mkOption {
        default = [ ];
        type = with lib.types; listOf package;
      };
      loginShell = {
        appl = lib.mkOption {
          default = "durden";
          type = lib.types.str;
        };
        enable = lib.mkEnableOption "loginShell";
        targets = lib.mkOption {
          type =
            with lib.types;
            attrsOf (
              submodule (
                { name, ... }:
                {
                  config.name = lib.mkDefault name;
                  options = {
                    argv = lib.mkOption {
                      default = [ ];
                      type = with lib.types; listOf singleLineStr;
                    };
                    bfrm = lib.mkOption {
                      type =
                        with lib.types;
                        enum [
                          "BIN"
                          "LWA"
                          "GAME"
                          "SHELL"
                          "EXTERNAL"
                        ];
                    };
                    exec = lib.mkOption {
                      type = lib.types.pathInStore;
                    };
                    name = lib.mkOption {
                      type = lib.types.singleLineStr;
                    };
                    tag = lib.mkOption {
                      default = "";
                      type = lib.types.singleLineStr;
                    };
                  };
                }
              )
            );

        };
        tty = lib.mkOption {
          default = 1;
          type = lib.types.ints.between 1 10;
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      loginShellInit = lib.mkIf cfg.loginShell.enable ''
        if [[ -z $ARCAN_APPLBASEPATH && $XDG_VTNR -eq ${toString cfg.loginShell.tty} ]]; then
          export ARCAN_APPLSTOREPATH='.arcan/appl-out'
          export ARCAN_STATEBASEPATH='.arcan/savestates'

          ${toDB cfg.loginShell.targets}
          exec arcan ${cfg.loginShell.appl}
        fi
      '';
      systemPackages = [ wrapper ];
    };
    hardware.graphics.enable = true;
  };
}
