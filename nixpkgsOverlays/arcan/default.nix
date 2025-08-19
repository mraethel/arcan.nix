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
      rev = "459b0141c2e0f2b0";
      hash = "sha256-w+EOl49Cc6I+/i3TSNpbKjT9a2gXbop0YEu/eRckV+M=";
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
      rev = "5a137ecd752ac854";
      hash = "sha256-twnuOW4tqwLeU19+JiPJuHb9VpGv8EeHvNUQZhvGwCs=";
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
