{ pname
, version
, src
, branch
, compat-list

, lib
, stdenv
, cmake
, boost
, pkg-config
, ffmpeg
, fmt
, glslang
, httplib
, inih
, libusb1
, nlohmann_json
, openal
, openssl
, SDL2
, spirv-tools
, vulkan-headers
, vulkan-loader
, enableSdl2Frontend ? true
, enableQt ? true
, qtbase
, qtmultimedia
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    pkg-config
    ffmpeg
    glslang
  ] ++ lib.optionals enableQt [ wrapQtAppsHook ];

  buildInputs = [
    boost
    fmt
    httplib
    inih
    libusb1
    nlohmann_json
    openal
    openssl
    SDL2
    spirv-tools
    vulkan-headers
    vulkan-loader
  ] ++ lib.optionals enableQt [ qtbase qtmultimedia ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_LIBS" true)
    (lib.cmakeBool "ENABLE_SDL2_FRONTEND" enableSdl2Frontend)
    (lib.cmakeBool "ENABLE_QT" enableQt)
  ];

  hardeningDisable = [ "fortify3" ];

  postPatch = let
    branchCapitalized = (lib.toUpper (lib.substring 0 1 branch) + lib.substring 1 (-1) branch);
  in ''
    # Prepare compatibility list
    ln -s ${compat-list} ./dist/compatibility_list.json

    # Set build version
    echo 'set(BUILD_FULLNAME "${branchCapitalized} ${version}")' >> CMakeModules/GenerateBuildInfo.cmake
  '';

  postInstall = let
    libs = lib.makeLibraryPath [ vulkan-loader ];
  in lib.optionalString enableSdl2Frontend ''
    wrapProgram "$out/bin/mandarine" \
      --prefix LD_LIBRARY_PATH : ${libs}
  '' + lib.optionalString enableQt ''
    qtWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${libs}
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/mandarine3ds/mandarine";
    description = "Mandarine: A Nintendo 3DS emulator based on Citra";
    longDescription = ''
      Mandarine is a Nintendo 3DS emulator written in C++, based on the Citra project.
    '';
    license = licenses.gpl3Plus;  # Adjust based on the actual license
    platforms = platforms.linux;
    maintainers = with maintainers; [ yourName ];  # Replace with actual maintainers
  };
}
