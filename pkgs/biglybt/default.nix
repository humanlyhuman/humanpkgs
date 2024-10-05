# hello.nix
{
  lib,
  stdenv,
  fetchzip,
  swt,
  jre,
  gtk3,
  wrapGAppsHook3,
  nix-update-script,  
}:

stdenv.mkDerivation {
  pname = "biglybt";
  version = "3.7.0.0";

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [ 
    jre
    swt
    gtk3
  ];

  configurePhase = ''
    runHook preConfigure

    sed -e 's/AUTOUPDATE_SCRIPT=1/AUTOUPDATE_SCRIPT=0/g' \
      -i biglybt || die

    runHook postConfigure
  '';
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(v[0-9.]+)$"
    ];
  };
  src = fetchzip {
    url = "https://github.com/BiglySoftware/BiglyBT/releases/download/v3.7.0.0/GitHub_BiglyBT_unix.tar.gz";
    sha256 = "sha256-pjoaDO0cnhVMK1EckrWna6gB5du5ZxgySvxKrbB2N4o=";
  };
  installPhase   = ''
    runHook preInstall
    install -d $out/{share/{biglybt,applications,icons/hicolor/scalable/apps},bin}
    cp -r ./* $out/share/biglybt/
    ln -s $out/share/biglybt/biglybt.desktop $out/share/applications/ 
    ln -s $out/share/biglybt/biglybt.svg $out/share/icons/hicolor/scalable/apps/
    wrapProgram $out/share/biglybt/biglybt \
      --prefix PATH : ${lib.makeBinPath [ jre ]}
    ln -s $out/share/biglybt/biglybt $out/bin/
    runHook postInstall
    mkdir -p $out/bin
    cp -r ./* $out/bin 
  '';
}