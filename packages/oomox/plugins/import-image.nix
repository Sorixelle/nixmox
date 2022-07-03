{ oomox }:

oomox.buildPlugin {
  name = "import-image";
  pythonDeps = ps: with ps; [ pillow ];

  installTargets = [ "install_import_images" ];
}
