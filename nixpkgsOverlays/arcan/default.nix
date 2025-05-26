final: prev: {
  arcan = (prev.arcan.overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs ++ (with final; [
      libunwind
      libuvc
      lua
      luajit
      openal
      sqlite
    ]);
    patches = [ ];
  })).override {
    sources = final.callPackage ./sources.nix { };
    useBuiltinLua = false;
    useStaticLibuvc = false;
    useStaticOpenAL = false;
    useStaticSqlite = false;
  };
  cat9 = prev.cat9.overrideAttrs (_: {
    postPatch = ''
      ln -s cat9.lua default.lua
    '';
    src = final.fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/cat9";
      rev = "c4ebf5087bd17c9c9a732220c913042ee3957e9a";
      hash = "sha256-I4LvjxVcz7KYocISa/75OPAbxUZ6jArLfHhjVfRVNzY=";
    };
    version = "2025-05-19";
  });
  durden = prev.durden.overrideAttrs (_: {
    installPhase = ''
      runHook preInstall

      mkdir -p ${placeholder "out"}/share/arcan/appl
      cp -a ./durden ${placeholder "out"}/share/arcan/appl/

      mkdir -p ${placeholder "out"}/bin
      cp ./distr/durden ${placeholder "out"}/bin/

      runHook postInstall
    '';
    patches = [ ./durden.diff ];
    postPatch = ''
      substituteInPlace ./distr/durden \
        --replace-fail "/usr/share/\$applname/\$applname" "$out/share/arcan/appl/\$applname" \
        --replace-fail "/bin/arcan" "${final.arcan-wrapped}/bin/arcan"
    '';
    src = final.fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/durden";
      rev = "88f8455534c6117c1171fa50782e1974bc4a667f";
      hash = "sha256-AEbrXBt4d0C7HxpDb2IL75vOYK+A4N3NDQLbb5F9g0M=";
    };
    version = "2025-03-12";
  });
  xarcan = prev.xarcan.overrideAttrs (prevAttrs: {
    src = final.fetchFromGitHub {
      owner = "letoram";
      repo = "xarcan";
      rev = "3e1f52252582d9aff5fb9f09ef6f1182813467b2";
      hash = "sha256-lZRPCzL3MwUgsZGg9kmBmwsHp16H5AQDbHeVTAmKfm4=";
    };
    version = "2025-02-25";
  });
}
