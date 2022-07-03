{ stdenv
, lib
, pkgs
, fetchFromGitHub
, python3
, gtk3
, gdk-pixbuf
, gobject-introspection
, wrapGAppsHook
, withPlugins

, plugins ? [ ]
}:

let
  collectPluginAttrs = attr: builtins.map (p: p.${attr}) (builtins.filter (p: (p ? ${attr})) plugins);
  callPluginFunctions = attr: arg: builtins.concatMap (f: f arg) (collectPluginAttrs attr);

  pythonEnv = python3.withPackages (ps: with ps; let
    pluginPackages = callPluginFunctions "pythonPackages" ps;
  in
  [ pygobject3 ] ++ pluginPackages);
in
stdenv.mkDerivation rec {
  pname = "oomox";
  version = "1.14";

  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  buildInputs =
    let
      pluginPackages = callPluginFunctions "buildInputs" pkgs;
    in
    [ gdk-pixbuf gtk3 pythonEnv ] ++ pluginPackages;

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

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  installTargets =
    let
      pluginTargets = collectPluginAttrs "makeTargets";
    in
    [ "install_gui" ] ++ pluginTargets;

  passthru = {
    inherit withPlugins;
  };
}
