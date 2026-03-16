{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  eigen,
  libGL,
  glm,
  glfw3,
  libpng,
  libjpeg,
  imgui,
  zlib,
  tree,
}:

stdenv.mkDerivation rec {
  pname = "iridescence";
  version = "master";

  src = fetchFromGitHub {
    owner = "koide3";
    repo = "iridescence";
    rev = "3200572daaf2ea11f660936890244d66efc727da";
    hash = "sha256-gQCRZAt+9NsIjZhnk+Fxnzp14Lsl3jhoBT4vsgiFv1g=";
    fetchSubmodules = true;
  };

  patches = [];

  nativeBuildInputs = [
    cmake
    pkg-config
    tree
  ];
  buildInputs = [
    eigen
    libGL
    glm
    glfw3
    libpng
    libjpeg
    imgui
    zlib
  ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    ls -la thirdparty
    tree thirdparty
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    description = "Visualization library for rapid prototyping of 3D algorithms [C++, Python]";
    homepage = "https://github.com/koide3/iridescence";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.omgbebebe ];
    platforms = lib.platforms.linux;
  };
}
