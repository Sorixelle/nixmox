{ oomox, fetchFromGitHub, bc, librsvg }:

oomox.buildPlugin {
  name = "icons-gnome-colors";

  gnomeColorsIconsSrc = fetchFromGitHub {
    owner = "themix-project";
    repo = "gnome-colors-icon-theme";
    rev = "cd8b05afb3eab734f7b10f518110984f99257a20";
    sha256 = "R6lCFzJ7xJK/qXcLirGfCbKpLfaAG0Kydc6+lCKaudg=";
  };
  gnomeColorsIconsPatch = ./patches/icons-gnomecolors.patch;

  propagatedBuildInputs = [ bc librsvg ];

  installTargets = [ "install_icons_gnomecolors" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_gnomecolors/gnome-colors-icon-theme

    for file in $gnomeColorsIconsSrc/*; do
      ln -s $file .
    done

    rm change_color.sh gnome-colors
    mkdir gnome-colors
    for file in $gnomeColorsIconsSrc/gnome-colors/*; do
      ln -s $file gnome-colors/
    done
    rm gnome-colors/Makefile

    cp $gnomeColorsIconsSrc/change_color.sh .
    cp $gnomeColorsIconsSrc/gnome-colors/Makefile gnome-colors/
    chmod u+w change_color.sh gnome-colors/Makefile

    patch -p1 < $gnomeColorsIconsPatch
    substituteInPlace $out/bin/oomox-gnome-colors-icons-cli --replace "/opt/oomox/" "$out/opt/oomox/"
  '';

  generateThemeType = "icon";
  generateCmd = "/bin/oomox-gnome-colors-icons-cli";
}
