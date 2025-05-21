final: prev: {
  arcan = (prev.arcan.override {
    sources = final.callPackage ./sources.nix { };
    useBuiltinLua = false;
    useStaticLibuvc = false;
    useStaticOpenAL = false;
    useStaticSqlite = false;
  }).overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs ++ (with final; [
      libunwind
      libuvc
      lua
      luajit
      openal
      sqlite
    ]);
    patches = [ ];
  });
  cat9 = prev.cat9.overrideAttrs (_: {
    src = final.fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/cat9";
      rev = "bfc1bf35e6";
      hash = "sha256-Yx2CXNVkGu8ryGXDEq9RgiYR01ceBQ/4jdRWub7la84=";
    };
  });
  durden = prev.durden.overrideAttrs (_: {
    src = final.fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/durden";
      rev = "88f8455534";
      hash = "sha256-AEbrXBt4d0C7HxpDb2IL75vOYK+A4N3NDQLbb5F9g0M=";
    };
  });
}
