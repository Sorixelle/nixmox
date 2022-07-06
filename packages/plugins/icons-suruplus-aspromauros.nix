{ oomox, fetchFromGitHub }:

oomox.buildPlugin {
  name = "icons-suruplus-aspromauros";

  suruplusAspromaurosIconsSrc = fetchFromGitHub {
    owner = "gusbemacbe";
    repo = "suru-plus-aspromauros";
    rev = "d43a8ec43804c91d782be2d411da6ddccf32fcb1";
    sha256 = "TLXicDAb7VmzjwCsKtNTnSDq8Z8P1ZBJTMcghF0r0gk=";
  };
  suruplusAspromaurosIconsPatch = ./patches/icons-suruplus-aspromauros.patch;

  installTargets = [ "install_icons_suruplus_aspromauros" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_suruplus_aspromauros
    patch -p1 < $suruplusAspromaurosIconsPatch

    cd suru-plus-aspromauros
    cp -r $suruplusAspromaurosIconsSrc/* .
  '';

  generateThemeType = "icon";
  generateCmd = "/opt/oomox/plugins/icons_suruplus_aspromauros/change_color.sh";
}
