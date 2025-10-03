{
  fetchfossil,
}:
{
  letoram-arcan = {
    pname = "arcan";
    version = "0.7.0.2";

    src = fetchfossil {
      url = "https://chiselapp.com/user/letoram/repository/arcan";
      rev = "8d3b5f76751580e3";
      hash = "sha256-qHA2aC6JZzFXjqyXG1/QiFI1KggL3OMAW5vdHRFA1ec=";
    };
  };
}
