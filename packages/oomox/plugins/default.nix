{ pkgs }:

let
  inherit (pkgs) oomox;
in
{
  export-xresources = oomox.buildPlugin {
    name = "export-xresources";

    installTargets = [ "install_export_xresources" ];
  };

  import-image = oomox.buildPlugin {
    name = "import-image";
    pythonDeps = ps: with ps; [ pillow ];

    installTargets = [ "install_import_images" ];
  };

  import-xresources = oomox.buildPlugin {
    name = "import-xresources";
    propagatedBuildInputs = [ pkgs.xorg.xrdb ];

    installTargets = [ "install_import_xresources" ];
  };
}
