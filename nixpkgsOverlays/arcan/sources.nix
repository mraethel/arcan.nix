{ fetchfossil
, fetchFromGitHub
}: {
  letoram-arcan = rec {
    pname = "arcan";
    version = "0.7.0.2";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "9ca7d1d099c6da2f32f2da0f8cf3864a28a950e1";
      hash = "sha256-AbIMZOyEvRQzlmNetImLnBBoSaFUsy4k1NNSO0mI8FI=";
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

  letoram-tracy = {
    pname = "letoram-tracy";
    version = "0-unstable-2024-04-12";

    src = fetchFromGitHub {
      owner = "letoram";
      repo = "tracy";
      rev = "5b3513d9838317bfc0e72344b94aa4443943c2fd";
      hash = "sha256-hUdYC4ziQ7V7T7k99MERp81F5mPHzFtPFrqReWsTjOQ=";
    };
  };
}
