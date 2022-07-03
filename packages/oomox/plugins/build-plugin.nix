{ stdenv, oomox }:

{ name
, installTargets
, pythonDeps
, ...
}@_args:

let
  args = builtins.removeAttrs _args [ "name" "installTargets" "pythonDeps" ];
in
stdenv.mkDerivation ({
  pname = "oomox-plugin-${name}";
  inherit (oomox) version src;

  dontBuild = true;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  inherit installTargets;

  passthru = {
    pythonDeps = ps: with ps; [ pillow ];
  };
} // args)
