{ fetchfossil
, fetchFromGitHub
}: {
  letoram-arcan = rec {
    pname = "arcan";
    version = "0.7.0.2";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "fa1528c3641b0d3e";
      hash = "sha256-W3lUBspYadDSFHnLf82CSLW3KYOeRrYVL5areKMHTDc=";
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
