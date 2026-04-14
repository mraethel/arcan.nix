final: prev: {
  qutebrowser = prev.qutebrowser.overrideAttrs (prevAttrs: {
    preFixup =
      with final.lib;
      concatLines (filter (str: !(hasInfix "QT_PLUGIN_PATH" str)) (splitString "\n" prevAttrs.preFixup));
  });
}
