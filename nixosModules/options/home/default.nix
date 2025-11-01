{
  arcan,
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.programs.arcan;
in
{
  options.users.arcanUsers = lib.mkOption {
    default = [ ];
    type = with lib.types; listOf str;
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (builtins.length config.users.arcanUsers) == 0 || options ? "home-manager";
        message = "Configure home-manager to use this option!";
      }
      {
        assertion = builtins.all (user: config.users.users ? user) config.users.arcanUsers;
        message = "Arcan users must exist!";
      }
    ];
    home-manager.users = lib.mkMerge (
      map (user: {
        ${user}.imports = [
          {
            programs.arcan = {
              enable = true;
              appls = lib.optionals (cfg.durden.enable) [ "durden" ];
            };
          }
        ]
        ++ [ arcan.homeModules.options.default ];
      }) config.users.arcanUsers
    );
  };
}
