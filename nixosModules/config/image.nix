{
  lib,
  localLib,
  nixpkgs,
  pkgs,
  ...
}:
{
  environment.etc = pkgs.lib.dir2Etc {
    prefix = "nixos/";
    src =
      with lib.fileset;
      (toSource rec {
        root = ../..;
        fileset = fileFilter (file: file.name != "result") root;
      });
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };
  image.modules = rec {
    default = {
      imports = [ "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix" ];
      installer.cloneConfig = false;
      isoImage.appendToMenuLabel = " Live System";
      system.nixos = {
        distroName = "Arcan";
        version = pkgs.arcan.version;
      };
    };
    "x86_64-linux" = default // { nixpkgs.hostPlatform = "x86_64-linux"; };
    "aarch64-linux" = default // { nixpkgs.hostPlatform = "aarch64-linux"; };
  };
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    overlays = [ (final: prev: { lib = prev.lib // localLib { inherit lib; }; }) ];
  };
  time.timeZone = "America/New_York";
  users.users.nixos.extraGroups = [ "input" ];
}
