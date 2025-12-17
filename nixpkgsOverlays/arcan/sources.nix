{
  fetchfossil,
  fetchFromGitHub,
  luajit,
}:
{
  inherit luajit;
  letoram-arcan = {
    pname = "arcan";
    version = "0.7.0.1-unstable-2025-10-16";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "a10088d87c9d19cf";
      hash = "sha256-7UeoejqC3HMZq0R60QFbsVbWr5LO200mJC8TNdXgHR0=";
    };
  };
  letoram-openal.src = fetchFromGitHub {
    owner = "letoram";
    repo = "openal";
    rev = "731bdaefeb9cfcc52267bb8fc884248e4420e9ec";
    hash = "sha256-jrgZRekhEiztJ8vodWnCpeYmT54Ei/c27XrD5S98gjk=";
  };
  libuvc.src = fetchFromGitHub {
    # nixpkgs libuvc is ancient
    owner = "libuvc";
    repo = "libuvc";
    rev = "047920bcdfb1dac42424c90de5cc77dfc9fba04d";
    hash = "sha256-Ds4N9ezdO44eBszushQVvK0SUVDwxGkUty386VGqbT0=";
  };
}
