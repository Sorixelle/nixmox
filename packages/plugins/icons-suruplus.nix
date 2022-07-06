{ oomox, fetchFromGitHub }:

oomox.buildPlugin {
  name = "icons-suruplus";

  suruplusIconsSrc = fetchFromGitHub {
    owner = "gusbemacbe";
    repo = "suru-plus";
    rev = "a0ad032f0223b7b25f46ad7af50252bd8f8948b6";
    sha256 = "8eIcQBqnAU8cQCgcXL0lKKQgRyN0NJW6+nau+4cxh3Y=";
  };
  suruplusIconsPatch = ./patches/icons-suruplus.patch;

  installTargets = [ "install_icons_suruplus" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_suruplus
    patch -p1 < $suruplusIconsPatch

    cd suru-plus
    ln -s $suruplusIconsSrc/* .
  '';

  generateThemeType = "icon";
  generateCmd = "/opt/oomox/plugins/icons_suruplus/change_color.sh";
}
