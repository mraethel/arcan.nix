{
  arcan,
  appls ? [ ],
  doas,
  fossil,
  gdb,
  inotify-tools,
  lldb,
  name ? "arcan-wrapped",
  nvim-arcan,
  symlinkJoin,
  wpa_supplicant,
}:
let
  appls-wrapped = symlinkJoin {
    name = "arcan-appls";
    paths = appls ++ [ arcan ];
  };
in arcan.overrideAttrs (prevAttrs: {
  pname = name;
  buildInputs = prevAttrs.buildInputs ++ [
    doas
    fossil
    gdb
    inotify-tools
    lldb
    nvim-arcan
    wpa_supplicant
  ];
  postPatch = ''
    substituteInPlace ./src/platform/posix/paths.c \
      --replace-fail "/usr/bin" "$out/bin" \
      --replace-fail "/usr/share" "${appls-wrapped}/share"
    substituteInPlace ./src/CMakeLists.txt \
      --replace-fail "SETUID" "# SETUID"
  '';
  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram $prog \
        --prefix PATH ":" "$out/bin" \
        --set ARCAN_APPLBASEPATH "${appls-wrapped}/share/arcan/appl/" \
        --set ARCAN_BINPATH "$out/bin/arcan_frameserver" \
        --set ARCAN_LIBPATH "$out/lib/" \
        --set ARCAN_RESOURCEPATH "${appls-wrapped}/share/arcan/resources/" \
        --set ARCAN_SCRIPTPATH "${appls-wrapped}/share/arcan/scripts/" \
        --set LASH_BASE "${appls-wrapped}/share/arcan/lash"
    done
  '';
})
