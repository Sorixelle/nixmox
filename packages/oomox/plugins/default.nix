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

  base16 = pkgs.callPackage ./base16.nix { };

  icons-archdroid = pkgs.callPackage ./icons-archdroid.nix { };

  theme-materia = pkgs.callPackage ./theme-materia.nix { };
  theme-oomox = pkgs.callPackage ./theme-oomox.nix { };
}
