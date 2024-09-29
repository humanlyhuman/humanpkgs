{  pkgs, fetchFromGitHub, ... }:

pkgs.python3Packages.buildPythonApplication {
  pname = "nbt";
  version = "master";

  propagatedBuildInputs = with pkgs.python3Packages; [
    flask
  ];

  src = fetchFromGitHub {
    owner = "twoolie";
    repo = "nbt";
    rev = "master";
    sha256 = "sha256-FmRvqCyHJpWNjGr+CFXXy/ppeXbOuvXGDCfYlqK0BPE=";
  };
}
