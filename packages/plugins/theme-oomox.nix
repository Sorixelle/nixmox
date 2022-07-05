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
    cp -r $oomoxThemeSrc/* .
    chmod -R u+w *
    patch -p1 < $oomoxThemePatch
    popd
  '';
}
