{
  fetchfossil,
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
}
