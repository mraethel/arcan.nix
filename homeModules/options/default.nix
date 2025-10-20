{ config, lib, ... }:
let
  cfg = config.programs.arcan;
  state_base = if config.xdg.enable then "${config.xdg.stateHome}/arcan" else ".arcan/savestates";
  store_base = if config.xdg.enable then "${config.xdg.dataHome}/arcan" else ".arcan/appl-out";
  store_paths = [
    "output"
    "ipc"
    "debug"
    "devmaps/display"
    "devmaps/keyboard"
    "devmaps/game"
    "devmaps/led"
    "devmaps/schemes"
    "devmaps/touch"
    "tools"
    "widgets"
  ];
in
{
  options.programs.arcan = {
    enable = lib.mkEnableOption "Arcan";
    appls = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge (
      [
        { "${state_base}/.keep".text = ""; }
      ]
      ++ (map
        (
          attrs: with attrs; {
            "${store_base}/${appl}/${store_path}/.keep".text = "";
          }
        )
        (
          lib.cartesianProduct {
            store_path = store_paths;
            appl = cfg.appls;
          }
        )
      )
    );
    systemd.user.sessionVariables = {
      ARCAN_APPLSTOREPATH = store_base;
      ARCAN_STATEBASEPATH = state_base;
    };
  };
}
