{
  arcan,
  meson,
  msgpack-c,
  ninja,
  pkg-config,
  src,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvim-arcan";
  version = "2024-02-20";

  inherit src;

  patches = [ ./nvim-arcan-msgpack.diff ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    arcan
    msgpack-c
  ];
})
