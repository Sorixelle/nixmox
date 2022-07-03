{
  image = {
    makeTargets = [ "install_import_images" ];
    pythonPackages = ps: [ ps.pillow ];
  };

  xresources = {
    makeTargets = [ "install_import_xresources" "install_export_xresources" ];
    buildInputs = pkgs: [ pkgs.xorg.xrdb ];
  };
}
