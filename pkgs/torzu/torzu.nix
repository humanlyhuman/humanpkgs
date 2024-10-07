{ lib
, stdenv
, fetchFromGitea
, nix-update-script
, wrapQtAppsHook
, autoconf
, boost
, catch2_3
, cmake
, compat-list
, cpp-jwt
, cubeb
, discord-rpc
, enet
, ffmpeg-headless
, fmt
, glslang
, libopus
, libusb1
, libva
, lz4
, nlohmann_json
, nv-codec-headers-12
, nx_tzdb
, pkg-config
, qtbase
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, SDL2
, vulkan-headers
, vulkan-loader
, yasm
, zlib
, zstd
, ...
}:
stdenv.mkDerivation(finalAttrs: {
  pname = "torzu";
  version = "master";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "litucks";
    repo = "torzu";
    rev = "15470284cf710f9d9ab926283c9ecc91714ba01b";
    hash = "sha256-s3zpeb4BGHz30ZlV97WsLI/CY4rQPdnaBy4tGBnqHxo=";
    fetchSubmodules = true;
};

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers

    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    # ffmpeg deps (also includes vendored)
    # we do not use internal ffmpeg because cuda errors
    autoconf
    yasm
    libva  # for accelerated video decode on non-nvidia
    nv-codec-headers-12  # for accelerated video decode on nvidia
    ffmpeg-headless
    # end ffmpeg deps

    fmt
    # intentionally omitted: gamemode - loaded dynamically at runtime
    # intentionally omitted: httplib - upstream requires an older version than what we have
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    # not packaged in nixpkgs: simpleini
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    # not packaged in nixpkgs: vulkan-memory-allocator
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    "-DYUZU_ENABLE_LTO=ON"
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"
    "-DYUZU_USE_EXTERNAL_SDL2=OFF"
    "-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"
    "-DYUZU_CHECK_SUBMODULES=OFF"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DYUZU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" 
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH:${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';


  postInstall = "
    install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-yuzu-input.rules
  ";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "mainline-0-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://notabug.org/litucks/torzu";
    changelog = "https://notabug.org/litucks/torzu";
    description = "An experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the master/ branch is recommended for general usage.
      Using the dev branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "torzu";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons
      asl20 mit cc0
    ];
  };
})
