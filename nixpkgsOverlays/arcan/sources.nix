{
  fetchfossil,
  fetchFromCodeberg,
  fetchFromGitHub,
  luajit,
}:
{
  inherit luajit;
  letoram-arcan = {
    pname = "arcan";
    version = "0.7.2-unstable-2026-10-18";

    src = fetchFromCodeberg {
      owner = "letoram";
      repo = "arcan";
      rev = "8af5b822847f3a9e90cede94937c477fac2c7e48";
      hash = "sha256-aPl4jvGnmJ3r+ZpfgwctqT7DsFg3/TfD55Ce4LC10jA=";
    };
    # src = fetchfossil {
    #   url = "https://chiselapp.com/user/letoram/repository/arcan";
    #   rev = "2a5c5240fe2d1c27";
    #   hash = "sha256-Y57xSwLw+L0A2zDuB2liuT1f9QUgzDCicMkjcrZe7kE=";
    # };
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
