{
  fetchgit,
  libxkbcommon,
  src,
  stdenv,
  xkeyboard-config,
}:
stdenv.mkDerivation {
  pname = "xkb2kbdlua";
  version = "0-unstable-2025-10-28";
  inherit src;
  buildInputs = [
    libxkbcommon
    xkeyboard-config
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp xkb2kbdlua $out/bin

    mkdir -p $out/share/arcan/appl
    cp -r tester $out/share/arcan/appl

    cp keyboard.lua $out/share/arcan/appl/tester/builtin

    runHook postInstall
  '';
}
