{
  arcan,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.arcan.durden;
  optionalArgs =
    kmp:
    builtins.concatStringsSep " " (
      lib.attrsets.mapAttrsToList (k: v: "-${builtins.substring 0 1 k} ${v}") (
        lib.attrsets.filterAttrs (_: v: v != "") kmp
      )
    );
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
  toDevmaps =
    kmps:
    lib.attrsets.mapAttrsToList (
      name: kmp:
      pkgs.runCommand "xkb2kbdlua-${kmp.model}-${kmp.layout}"
        { buildInputs = [ arcan.packages.${pkgs.system}.xkb2kbdlua ]; }
        ''
          mkdir -p $out/share/arcan/appl/durden/devmaps/keyboard
          cd $out/share/arcan/appl/durden/devmaps/keyboard

          xkb2kbdlua ${optionalArgs kmp} -n ${name}
        ''
    ) kmps;
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
    keymaps = lib.mkOption {
      default.default.layout = "en";
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            layout = lib.mkOption { type = str; };
            model = lib.mkOption {
              default = "pc105";
              type = str;
            };
            options = lib.mkOption {
              default = "grp:caps_toggle,compose:ralt,grp_led:scroll";
              type = str;
            };
            rules = lib.mkOption {
              default = "";
              type = str;
            };
            variant = lib.mkOption {
              default = "";
              type = str;
            };
          };
        });
    };
  };
  config.programs.arcan.appls = lib.mkIf cfg.enable (
    [
      cfg.package
      (toAutorun cfg.autorun.config cfg.autorun.extra)
      (toConfig cfg.config)
      (toFirstrun cfg.firstrun)
    ]
    ++ (toDevmaps cfg.keymaps)
  );
}
