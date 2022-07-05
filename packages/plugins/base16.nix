{ oomox, fetchFromGitHub }:

oomox.buildPlugin {
  name = "base16";

  base16Src = fetchFromGitHub {
    owner = "themix-project";
    repo = "themix-plugin-base16";
    rev = "f07e291946e6fcc26b9f4099dd9217ae4424a527";
    sha256 = "uqLi/CjHCaOX54Bcg58NDHlr53G7YDSByxGhxSI/fHY=";
  };

  pythonDeps = ps: with ps; [ pystache pyyaml ];

  installTargets = [ "install_plugin_base16" ];

  preInstall = ''
    cp -r $base16Src/* plugins/base16/
  '';
}
