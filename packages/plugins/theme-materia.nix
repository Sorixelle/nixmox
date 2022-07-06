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
    cp -r $materiaThemeSrc/* .
    chmod -R u+w *
    patch -p1 < $materiaThemePatch

    substituteInPlace $out/bin/oomox-materia-cli --replace "/opt/oomox/" "$out/opt/oomox/"
  '';

  generateCmd = "/bin/oomox-materia-cli";
}
