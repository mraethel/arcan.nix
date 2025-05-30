{ arcan
, makeWrapper
, meson
, msgpack
, ninja
, pkg-config
, src
, stdenv
}: stdenv.mkDerivation (finalAttrs: {
  pname = "nvim-arcan";
  version = "2024-02-20";

  inherit src;

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    arcan
    msgpack
  ];
})
