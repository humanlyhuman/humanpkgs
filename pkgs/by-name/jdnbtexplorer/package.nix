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

  # Fetching source from GitHub
  src = fetchFromGitHub {
    owner = "JakobDev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aBEYzrjVRbYJsaUlHVBJbucZNWk9rgTADstbQxucEz4=";
  };

  # Dependencies for runtime and build
  propagatedBuildInputs = [
    python3Packages.pyqt6 
    pkgs.qt6.qtbase  # Use Qt6 base for PyQt6
    pkgs.gettext
    python3Packages.nbtlib 

  ];

  nativeBuildInputs = [
    pkgs.qt6.qttools  # Use Qt6 tools for pyuic6
    makeWrapper
    python3Packages.nbtlib
   ];

  # Ensure pyuic6 is available in PATH
  preBuild = ''
    mkdir -p dist  # Create dist directory to prevent "No such file or directory" errors
    export PATH=${python3Packages.pyqt6}/bin:$PATH
    export PATH=${python3Packages.nbtlib}/bin:$PATH
  '';
  format = "pyproject";

  # Post-install phase to set up application
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
  