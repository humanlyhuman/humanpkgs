{ lib
, stdenv
, fetchFromGitHub
, cmake
, ffmpeg
, libglut
, freeimage
, glew
, glfw
, glm
, libGL
, libpulseaudio
, libX11
, libXau
, libXdmcp
, libXext
, libXpm
, libXrandr
, libXxf86vm
, lz4
, mpv
, pkg-config
, SDL2
, SDL2_mixer
, zlib
}:

stdenv.mkDerivation {
  pname = "linux-wallpaperengine";
  version = "unstable-2023-10-13";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "ec60a8a57153e49e3684c864a6d809fe9601336b";
    hash = "sha256-M77Wp6tCXO2oFgfZ0+mdBT07CCYLsDDyHjeHtaDVvu8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libglut
    freeimage
    glew
    glfw
    glm
    libGL
    libpulseaudio
    libX11
    libXau
    libXdmcp
    libXext
    libXrandr
    libXpm
    libXxf86vm
    mpv
    lz4
    SDL2
    SDL2_mixer.all
    zlib
  ];

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Only;
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
}