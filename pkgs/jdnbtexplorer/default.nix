{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools
, setuptools-scm

# dependencies
, attrs
, py
, setuptools
, ...
 }:

buildPythonPackage rec {
  pname = "jdnbtexplorer";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-089d08250261e294572b4f7d46a0ba95dc4c55d1";
  };


  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    py
    setuptools
  ];

  meta = {
    changelog = "https://codeberg.org/JakobDev/jdNBTExplorer/releases/tag/${version}";
    description = "A Editor for Minecraft NBT files";
    homepage = "https://codeberg.org/JakobDev/jdNBTExplorer/";
  };
}