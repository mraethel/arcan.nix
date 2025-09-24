self: final: prev: {
  inherit (self.packages.${final.system}) nvim-arcan;
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
      rev = "e7fc5ef3a6d81a8a";
      hash = "sha256-84MM4ZBkJjUJ4dDyiCkAdNz9OOPVpCNEvpaBWGIL0+U=";
    };
    version = "2025-08-17";
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
      rev = "9d499e84dc661e0f";
      hash = "sha256-PH799/6EVjSsCA7q2yny2USUhWIvYRxFrdYHJzCROfQ=";
    };
    version = "2025-08-10";
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
