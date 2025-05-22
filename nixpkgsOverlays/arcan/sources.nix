{ fetchfossil
, fetchFromGitHub
}: {
  letoram-arcan = rec {
    pname = "arcan";
    version = "0.7.0.2";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "9ca7d1d099c6da2f32f2da0f8cf3864a28a950e1";
      hash = "sha256-32Ley/l0w3/nxeowqZTdT2ld6hytEUWL6cBRAeCqwGQ=";
    };
  };

  tracy = {
    pname = "tracy";
    version = "v0.11.1";

    src = fetchFromGitHub {
      owner = "wolfpld";
      repo = "tracy";
      rev = "5d542dc09f3d9378d005092a4ad446bd405f819a";
      hash = "sha256-HofqYJT1srDJ6Y1f18h7xtAbI/Gvvz0t9f0wBNnOZK8=";
    };
  };
}
