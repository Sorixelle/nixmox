{ oomox, fetchFromGitHub, bc }:

oomox.buildPlugin {
  name = "icons-numix";

  numixIconsSrc = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-icon-theme";
    rev = "97c01aee9b5b88200843edf41597ab6f987e288b";
    sha256 = "j555/P7eP1ISwLcJoewPiu+f+XP/JKrLc23q4xLEn8Y=";
  };
  numixFoldersSrc = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-folders";
    rev = "6e3e41a806512cb94729b7f61b664b355075b4ed";
    sha256 = "NMJPVKG9SP7q8d0rK4ziesPptoXySmQpzjJ9tEdmzjI=";
  };
  numixIconsPatch = ./patches/icons-numix.patch;

  propagatedBuildInputs = [ bc ];

  installTargets = [ "install_icons_numix" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_numix
    patch -p1 < $numixIconsPatch

    cd numix-icon-theme
    ln -s $numixIconsSrc/* .

    cd ../numix-folders
    ln -s $numixFoldersSrc/* .
  '';

  generateThemeType = "icon";
  generateCmd = "/opt/oomox/plugins/icons_numix/change_color.sh";
}
