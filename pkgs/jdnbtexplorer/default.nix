{ lib, python3Packages, kdePackages, pkgs, fetchFromGitHub, substituteAll }:

python3Packages.buildPythonPackage rec {
  pname = "jdNBTExplorer";
  version = "2.1";
  format  = "pyproject";
  src = fetchFromGitHub {
    owner =  "JakobDev";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-aBEYzrjVRbYJsaUlHVBJbucZNWk9rgTADstbQxucEz4=";
    };
  dontWrapQtApps = true;  
  propagatedBuildInputs =     [ python3Packages.nbtlib python3Packages.pyqt6 python3Packages.pyside6  python3Packages.wheel pkgs.kdePackages.qttools ];
  dependencies = [ kdePackages.qttools ];
  doCheck = false;      

  meta = with lib; {
    homepage = "https://github.com/JakobDev/jdNBTExplorer";
    description = "A Editor for Minecraft NBT files";
    platforms = platforms.linux;
  };
}       