{
  fetchfossil,
  fetchFromGitHub,
  luajit,
}:
{
  letoram-arcan = {
    pname = "arcan";
    version = "0.7.0.2";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "770cb3ab6ca08253";
      hash = "sha256-7q0rIjwM4MXvHX6WpmAJFadvy+CLgV6HGTckTcxNC2g=";
    };
  };
  letoram-openal.src = fetchFromGitHub {
    owner = "letoram";
    repo = "openal";
    rev = "731bdaefeb9cfcc52267bb8fc884248e4420e9ec";
    hash = "sha256-jrgZRekhEiztJ8vodWnCpeYmT54Ei/c27XrD5S98gjk=";
  };
  libuvc.src = fetchFromGitHub {
    owner = "libuvc";
    repo = "libuvc";
    rev = "047920bcdfb1dac42424c90de5cc77dfc9fba04d";
    hash = "sha256-Ds4N9ezdO44eBszushQVvK0SUVDwxGkUty386VGqbT0=";
  };
  luajit.src = luajit.src;
}
