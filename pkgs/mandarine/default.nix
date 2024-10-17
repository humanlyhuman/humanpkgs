{ pkgs ? import <nixpkgs> {}, fetchurl, fetchFromGitHub }:

pkgs.callPackage ./mandarine.nix {
  pname = "mandarine";
  version = "latest";  # Specify the version
  src = fetchFromGitHub {
    owner = "mandarine3ds";
    repo = "mandarine";
    rev = "main";  # Specify the branch or commit
    sha256 = "sha256-0EF1WEhCFErv94BlPpYcsjTMc6sNF7nPNBE7s5QgRsc= ";  # Update this with the correct hash
    fetchSubmodules = true;
    leaveDotGit = true;
  };
  branch = "main";  # Adjust if necessary
  compat-list = fetchurl {
    name = "mandarine-compat-list";
    url = "https://web.archive.org/web/20231111133415/https://api.citra-emu.org/gamedb";  # Update if needed
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";  # Update with actual hash
  };
}
