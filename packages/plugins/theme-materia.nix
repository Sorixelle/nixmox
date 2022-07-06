{ oomox, fetchFromGitHub, bc, meson, ninja, nodePackages, optipng, parallel, resvg }:

oomox.buildPlugin {
  name = "theme-materia";

  materiaThemeSrc = fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
    sha256 = "0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
  };
  materiaThemePatch = ./patches/theme-materia.patch;

  propagatedBuildInputs = [ bc meson ninja nodePackages.sass optipng parallel resvg ];

  dontUseMesonConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;
  installTargets = [ "install_theme_materia" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/theme_materia/materia-theme

    for file in $materiaThemeSrc/*; do
      ln -s $file .
    done

    rm change_color.sh render-assets.sh src scripts
    cp -r $materiaThemeSrc/{change_color.sh,render-assets.sh,scripts} .
    chmod -R u+w change_color.sh render-assets.sh scripts

    mkdir src
    cd src
    for file in $materiaThemeSrc/src/*; do
      ln -s $file .
    done

    rm chrome gtk-2.0 gtk-3.0
    mkdir chrome gtk-2.0 gtk-3.0

    cd chrome
    for file in $materiaThemeSrc/src/chrome/*; do
      ln -s $file .
    done
    rm render-asset{,s}.sh
    cp $materiaThemeSrc/src/chrome/render-asset{,s}.sh .
    chmod u+w render-asset.sh

    cd ../gtk-2.0
    for file in $materiaThemeSrc/src/gtk-2.0/*; do
      ln -s $file .
    done
    rm assets.txt render-asset{,s}.sh
    cp $materiaThemeSrc/src/gtk-2.0/{assets.txt,render-asset{,s}.sh} .
    chmod u+w assets.txt render-asset.sh

    cd ../gtk-3.0
    for file in $materiaThemeSrc/src/gtk-3.0/*; do
      ln -s $file .
    done
    rm render-asset{,s}.sh
    cp $materiaThemeSrc/src/gtk-3.0/render-asset{,s}.sh .
    chmod u+w render-asset.sh

    cd ../../
    patch -p1 < $materiaThemePatch

    substituteInPlace $out/bin/oomox-materia-cli --replace "/opt/oomox/" "$out/opt/oomox/"
  '';

  generateCmd = "/bin/oomox-materia-cli";
}
