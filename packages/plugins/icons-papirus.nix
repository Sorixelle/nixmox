{ oomox, fetchFromGitHub }:

oomox.buildPlugin {
  name = "icons-papirus";

  papirusIconsSrc = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    rev = "9d01df775ce1c2eb4a1c2d5650cf3702d06b83bc";
    sha256 = "xaxMskKf1/7rjMqApndzLINlMNDwWKwOfE1tJvH8DcY=";
  };
  papirusIconsPatch = ./patches/icons-papirus.patch;

  installTargets = [ "install_icons_papirus" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_papirus
    patch -p1 < $papirusIconsPatch

    cd papirus-icon-theme
    cp -r $papirusIconsSrc/* .
  '';

  generateThemeType = "icon";
  generateCmd = "/opt/oomox/plugins/icons_papirus/change_color.sh";
}
