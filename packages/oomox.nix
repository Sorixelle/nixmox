{ stdenv, fetchFromGitHub, python3, gtk3, gdk-pixbuf, gobject-introspection, wrapGAppsHook }:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    pygobject3
  ]);
in stdenv.mkDerivation rec {
  pname = "oomox";
  version = "1.14";

  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  buildInputs = [ gdk-pixbuf gtk3 pythonEnv ];

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = pname;
    rev = version;
    sha256 = "MeLfVmc+9KjuDx8uJZ9t2HF81a+SWJSueFNZWRVE4YA=";
  };

  postPatch = ''
    substituteInPlace packaging/bin/oomox-gui \
      --replace "exec python3" ${pythonEnv}/bin/python \
      --replace "cd " "cd $out"
    substituteInPlace packaging/bin/themix-gui \
      --replace "exec python3" ${pythonEnv}/bin/python \
      --replace "cd " "cd $out"
  '';

  dontBuild = true;

  installPhase = ''
    make DESTDIR=$out PREFIX= install_gui
  '';
}
