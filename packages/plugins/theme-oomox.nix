{ oomox, fetchFromGitHub, bc, librsvg, sassc }:

oomox.buildPlugin {
  name = "theme-oomox";

  oomoxThemeSrc = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox-gtk-theme";
    rev = "f43b25554817935336394c4bf4d397325221dd84";
    sha256 = "YWDrHV17ua51swu/uiFkbr5MOUEGH9aoXzrDX0HofAs=";
  };
  oomoxThemePatch = ./patches/theme-oomox.patch;

  propagatedBuildInputs = [ bc librsvg sassc ];

  installTargets = [ "install_theme_oomox" ];

  preInstall = ''
    pushd plugins/theme_oomox/

    rsync -a --exclude=src $oomoxThemeSrc/* .
    chmod -R u+w *

    mkdir src
    pushd src
    for file in $oomoxThemeSrc/src/*; do
      ln -s $file .
    done
    popd

    patch -p1 < $oomoxThemePatch
    popd
  '';

  postInstall = ''
    substituteInPlace $out/bin/oomox-cli --replace "/opt/oomox/" "$out/opt/oomox/"
  '';

  generateCmd = "/bin/oomox-cli";
  generateParamsSpec = {
    hidpi = "hidpi";
    gtkVariant = "make-opts";
  };
}
