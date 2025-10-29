self: final: prev: {
  inherit (self.packages.${final.system}) nvim-arcan;
  arcan =
    (prev.arcan.overrideAttrs (prevAttrs: {
      # buildInputs =
      #   prevAttrs.buildInputs
      #   ++ (with final; [
      #     libunwind
      #     libuvc
      #     luajit
      #     openal
      #     sqlite
      #   ]);
      postInstall = ''
        ln -s /home ${placeholder "out"}/share/arcan/resources/home
      '';
      patches = [ ./arcan-cmakelists.diff ];
    })).override
      {
        sources = final.callPackage ./sources.nix { };
        # useBuiltinLua = false;
        # useStaticLibuvc = false;
        # useStaticOpenAL = false;
        # useStaticSqlite = false;
      };
  cat9 = prev.cat9.overrideAttrs (_: {
    installPhase = ''
      runHook preInstall

      mkdir -p ${placeholder "out"}/share/arcan/appl/cat9
      cp -a ./* ${placeholder "out"}/share/arcan/appl/cat9

      mkdir -p ${placeholder "out"}/share/arcan/lash
      ln -s ../appl/cat9/cat9.lua ${placeholder "out"}/share/arcan/lash/default.lua
      ln -s ../appl/cat9/cat9 ${placeholder "out"}/share/arcan/lash/cat9

      runHook postInstall
    '';
    src = final.fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/cat9";
      rev = "e7fc5ef3a6d81a8a";
      hash = "sha256-84MM4ZBkJjUJ4dDyiCkAdNz9OOPVpCNEvpaBWGIL0+U=";
    };
    version = "2025-08-17";
  });
  durden = prev.durden.overrideAttrs (_: {
    patches = [
      ./durden-autorun.diff
      ./durden-firstrun.diff
      ./durden-gconf.diff
    ];
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
