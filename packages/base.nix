{ stdenv
, lib
, pkgs
, fetchFromGitHub
, python3
, gtk3
, gdk-pixbuf
, gobject-introspection
, wrapGAppsHook

, extraPythonDeps ? (_: [ ])
}:

let
  pyenv = python3.withPackages (ps: with ps; [ pygobject3 ] ++ (extraPythonDeps ps));
in
stdenv.mkDerivation rec {
  pname = "oomox";
  version = "1.14";

  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  buildInputs = [ gdk-pixbuf gtk3 pyenv ];

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = pname;
    rev = version;
    sha256 = "MeLfVmc+9KjuDx8uJZ9t2HF81a+SWJSueFNZWRVE4YA=";
  };

  patches = [
    ./config-env-var.patch
  ];

  postPatch = ''
    substituteInPlace packaging/bin/oomox-gui \
      --replace "exec python3" ${pyenv}/bin/python \
      --replace "cd " "cd $out"
    substituteInPlace packaging/bin/themix-gui \
      --replace "exec python3" ${pyenv}/bin/python \
      --replace "cd " "cd $out"
  '';

  # Some plugins bring in meson/ninja as a propagated dep - don't run their hook
  dontUseMesonConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;
  dontBuild = true;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  installTargets = [ "install_gui" ];
}
