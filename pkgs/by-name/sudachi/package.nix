{
  lib,
  stdenv,
  autoconf,
  boost,
  catch2_3,
  cpp-jwt,
  cubeb,
  discord-rpc,
  enet,
  ffmpeg-headless,
  fmt,
  libopus,
  libusb1,
  libva,
  lz4,
  nlohmann_json,
  nv-codec-headers-12,
  SDL2,
  vulkan-headers,
  yasm,
  zlib,
  zstd,
  python3,
  fetchurl,
  autoPatchelfHook,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "sudachi";
  version = "1.0.10";

  src = fetchurl {
    url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v${version}/sudachi-linux-v${version}.7z";
    hash = "sha256-XVDedGj32Cze5TchCgj/A1pIaUkpd3CzaqCzOwcb02U=";
    downloadToTemp = true;
  };
  unpackPhase = ''
    echo 'e'
  '';
  buildPhase = ''
    # Ensure p7zip is available for extraction
    ${pkgs.p7zip}/bin/7z x ${src} -o. > /dev/null
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    pkgs.pkg-config
    vulkan-headers
    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    enet
    autoconf
    yasm
    libva
    fmt
    libopus
    pkgs.libusb
    lz4
    nlohmann_json
    pkgs.qt5.qtbase
    pkgs.qt5.qtmultimedia
    pkgs.qt5.qtwayland
    pkgs.qt5.qtwebengine
    pkgs.qt5.qttools
    SDL2
    pkgs.vulkan-loader
    zlib
    zstd
    pkgs.python3Full
    pkgs.xorg.libX11.dev
    pkgs.wayland-scanner
    pkgs.glslang
    pkgs.qt5.qtx11extras
    pkgs.makeWrapper
  ];
  __structuredAttrs = true;
  __propagatePkgConfigDepends = false;
  dontWrapQtApps = true;
  dbus = pkgs.dbus;
  buildInputs = [
    vulkan-headers
    dbus
    boost
    catch2_3
    pkgs.qt5.qtwayland
    cpp-jwt
    cubeb
    discord-rpc
    enet
    autoconf
    yasm
    libva # for accelerated video decode on non-nvidia
    nv-codec-headers-12 # for accelerated video decode on nvidia
    ffmpeg-headless
    python3
    fmt
    libopus
    libusb1
    lz4
    nlohmann_json
    pkgs.qt5.qtbase
    pkgs.qt5.qtmultimedia
    pkgs.qt5.qtwayland
    pkgs.qt5.qtwebengine
    pkgs.xorg.libX11.dev
    pkgs.wayland-scanner
    SDL2
    zlib
    zstd
    pkgs.qt5.qtx11extras

    pkgs.makeWrapper
  ];
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -m755 -D sudachi $out/bin/sudachi
    install -m755 -D sudachi-cmd $out/bin/sudachi-cmd
    install -m755 -D sudachi-room $out/bin/sudachi-room
    # Wrap the binaries to set environment variables
    wrapProgram $out/bin/sudachi --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/lib/qt/plugins/platforms"
    wrapProgram $out/bin/sudachi-cmd --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/lib/qt/plugins/platforms"
    wrapProgram $out/bin/sudachi-room --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/lib/qt/plugins/platforms"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://studio-link.com";
    description = "Voip transfer";
    platforms = platforms.linux;
  };
}
