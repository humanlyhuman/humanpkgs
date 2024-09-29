{ lib
, pkgs
, python3Packages
, fetchFromGitHub
, makeWrapper
, stdenv
}:

python3Packages.buildPythonPackage rec {
  pname = "jdNBTExplorer";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "JakobDev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aBEYzrjVRbYJsaUlHVBJbucZNWk9rgTADstbQxucEz4=";
  };

  propagatedBuildInputs = [
    python3Packages.pyqt6 
    pkgs.qt6.qtbase 
    pkgs.gettext
    python3Packages.nbtlib 

  ];

  nativeBuildInputs = [
    pkgs.qt6.qttools
    makeWrapper
    python3Packages.nbtlib
   ];

  preBuild = ''
    export PATH=${python3Packages.pyqt6}/bin:$PATH
    export PATH=${python3Packages.nbtlib}/bin:$PATH
  '';
  format = "pyproject";

  postInstall = ''
    # Install desktop entries and icons
    python3 ./install-unix-datafiles.py --prefix=$out

    # Wrapping the binary to ensure it finds Qt libraries
    wrapProgram $out/bin/jdNBTExplorer \
      --prefix QT_QPA_PLATFORM_PLUGIN_PATH : ${pkgs.qt6.qtbase}/lib/qt6/plugins/platforms
  '';
  dontWrapQtApps= true;
  meta = with lib; {
    description = "A tool to edit Minecraft NBT files";
    homepage = "https://github.com/JakobDev/jdNBTExplorer";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
  