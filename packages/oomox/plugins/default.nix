{ pkgs }:

let
  inherit (pkgs) oomox;
in
{
  import-image = oomox.buildPlugin {
    name = "import-image";
    pythonDeps = ps: with ps; [ pillow ];

    installTargets = [ "install_import_images" ];
  };
}
