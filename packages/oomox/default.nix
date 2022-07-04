{ symlinkJoin
, pkgs

, unwrapped
, withPlugins
, plugins ? [ ]
}:

let
  allPlugins = symlinkJoin {
    name = "oomox-plugins";
    paths = [ unwrapped ] ++ plugins;
  };

  basePkg = unwrapped.overrideAttrs (_: {
    passthru = {
      inherit withPlugins;
      buildPlugin = pkgs.callPackage ./plugins/build-plugin.nix { };
    };
  });
in
if builtins.length plugins == 0 then basePkg else
(basePkg.override {
  extraPythonDeps =
    ps: builtins.concatMap (p: if p ? pythonDeps then p.pythonDeps ps else [ ]) plugins;
}).overrideAttrs (old: {
  name = "${old.pname}-${old.version}-with-plugins";

  preFixup = ''
    gappsWrapperArgs+=(
      --set OOMOX_SCRIPT_DIR "${allPlugins}/opt/oomox/oomox_gui"
    )
  '';

  passthru = {
    inherit allPlugins unwrapped;
  };
})
