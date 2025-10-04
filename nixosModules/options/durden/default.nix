{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan.durden;
  toAutorun =
    cfg: ext:
    pkgs.writeTextDir "share/arcan/appl/durden/autorun-nixos.lua" ''
      local autorun_nixos = ${lib.generators.toLua { } cfg};

      for k,v in pairs(autorun_nixos) do
        gconfig_set(k,v,true); -- force config!
      end

      ${ext}
    '';
  toConfig =
    cfg:
    pkgs.writeTextDir "share/arcan/appl/durden/config-nixos.lua" ''
      local config_nixos = ${lib.generators.toLua { } cfg};
      for k,v in pairs(config_nixos) do
        gconfig_set(k,v); -- no force as sql is not yet present!
      end
    '';
  toFirstrun = ext: pkgs.writeTextDir "share/arcan/appl/durden/firstrun-nixos.lua" ext;

in
{
  options.programs.arcan.durden = {
    autorun = {
      config = lib.mkOption {
        default = { };
        description = "What is being configured at startup.";
        type = lib.types.attrs;
      };
      extra = lib.mkOption {
        default = "";
        description = "What is being run at startup.";
        type = lib.types.lines;
      };
    };
    config = lib.mkOption {
      default = { };
      description = "The default settings used on an empty database.";
      type = lib.types.attrs;
    };
    firstrun = lib.mkOption {
      default = "";
      description = "What is being run the first time durden is run.";
      type = lib.types.lines;
    };
    enable = lib.mkEnableOption "Durden";
    package = lib.mkPackageOption pkgs "durden" { };
  };
  config.programs.arcan.appls = lib.mkIf cfg.enable [
    cfg.package
    (toAutorun cfg.autorun.config cfg.autorun.extra)
    (toConfig cfg.config)
    (toFirstrun cfg.firstrun)
  ];
}
