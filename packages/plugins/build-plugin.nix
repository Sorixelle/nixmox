{ stdenv, lib, runCommandWith, oomox }:

{ name
, installTargets
, pythonDeps ? (_: [ ])
, generateThemeType ? "theme"
, generateCmd ? ""
, generateParamsSpec ? { }
, ...
}@_args:

let
  args = builtins.removeAttrs _args [ "name" "installTargets" "pythonDeps" "generateThemeType" "generateCmd" "generateParamsSpec" ];

  plugin = stdenv.mkDerivation ({
    pname = "oomox-plugin-${name}";
    inherit (oomox) version src;

    dontBuild = true;

    installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
    inherit installTargets;

    passthru = {
      inherit pythonDeps;

      generate =
        let
          pluginName = name;
        in
        { name, src, ... }@genArgs:
        if generateCmd == "" then builtins.throw "The ${pluginName} plugin can't be used to generate themes." else
        let
          rest = builtins.removeAttrs genArgs [ "name" "src" ];
          extraArgs =
            let
              argList = lib.mapAttrsToList
                (key: flag:
                  if rest ? ${key} then "--${flag} ${lib.generators.mkValueStringDefault {} rest.${key}}" else ""
                )
                generateParamsSpec;
            in
            builtins.concatStringsSep " " argList;
        in
        runCommandWith
          {
            inherit name;
            derivationArgs = {
              nativeBuildInputs = [ plugin ];
              themeFile = src;
              inherit extraArgs generateCmd;
            };
          }
          (''
            export HOME=$(pwd)/home
            mkdir -p $out/share/${generateThemeType}s
            ${plugin}$generateCmd -o "$name" ${
              if generateThemeType == "theme" then "-t $out/share/themes" else ""
            } $extraArgs $themeFile
          '' + (if generateThemeType != "icon" then "" else ''
            mv "$HOME/.icons/$name" $out/share/icons
          ''));
    };
  } // args);
in
plugin
