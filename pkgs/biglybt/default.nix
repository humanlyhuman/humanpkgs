# hello.nix
{
  stdenv,
  fetchzip,
  swt,
  jre,
  gtk3,
  maven
}:

stdenv.mkDerivation {
  pname = "biglybt";
  version = "3.7.0.0";

  buildInputs = [ 
    jre
    swt
    gtk3
  ];

  src = fetchzip {
    url = "https://github.com/BiglySoftware/BiglyBT/releases/download/v3.7.0.0/GitHub_BiglyBT_unix.tar.gz";
    sha256 = "sha256-pjoaDO0cnhVMK1EckrWna6gB5du5ZxgySvxKrbB2N4o=";
  };
  buildPhase = ''
    '';         
  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin 
  '';
}