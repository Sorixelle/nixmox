{ stdenv, oomox }:

stdenv.mkDerivation {
  pname = "oomox-plugin-import-image";
  inherit (oomox) version src;

  dontBuild = true;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  installTargets = [ "install_import_images" ];

  passthru = {
    pythonDeps = ps: with ps; [ pillow ];
  };
}
