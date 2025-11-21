{
  lib,
  ...
}:
{
  dir2Etc =
    { prefix, src }:
    lib.attrsets.listToAttrs (
      map (p: {
        name = prefix + lib.path.removePrefix (src.origSrc + "/") p;
        value = {
          source = p;
          mode = "0644";
        };
      }) (with lib.fileset; toList (fromSource src))
    );
}
