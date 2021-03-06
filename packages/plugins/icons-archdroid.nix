{ oomox, fetchFromGitHub }:

oomox.buildPlugin {
  name = "icons-archdroid";

  archdroidIconsSrc = fetchFromGitHub {
    owner = "themix-project";
    repo = "archdroid-icon-theme";
    rev = "775b8c2c03abff20a36417a26156b4103234a1ce";
    sha256 = "jou+9e4YJ4vSM47PWkh7mlegA7YMfbhEyLfMEQz70aQ=";
  };
  archdroidIconsPatch = ./patches/icons-archdroid.patch;

  installTargets = [ "install_icons_archdroid" ];

  postInstall = ''
    cd $out/opt/oomox/plugins/icons_archdroid/archdroid-icon-theme

    for file in $archdroidIconsSrc/*; do
      ln -s $file .
    done

    rm change_color.sh
    cp $archdroidIconsSrc/change_color.sh .
    chmod u+w change_color.sh

    patch -p1 < $archdroidIconsPatch
    substituteInPlace $out/bin/oomox-archdroid-icons-cli --replace "/opt/oomox/" "$out/opt/oomox/"
  '';

  generateThemeType = "icon";
  generateCmd = "/bin/oomox-archdroid-icons-cli";
}
