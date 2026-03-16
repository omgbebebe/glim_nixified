{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  eigen,
  gtsam,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gtsam_points";
  version = "master";

  src = fetchFromGitHub {
    owner = "koide3";
    repo = "gtsam_points";
    rev = "85d0f4c43098b1f071bbb07710692e3829347c6c";
    hash = "sha256-9DRVIAryrSF4dYRI8x7+vBB8tVFKyaEKQej7pBiNUgo=";
  };

  patches = [];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    gtsam
    eigen
    boost
    zlib
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DBUILD_WITH_CUDA=OFF"
    "-DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF"
    "-DGTSAM_BUILD_TESTS=OFF"
    "-DGTSAM_WITH_TBB=OFF"
    "-DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF"
  ];

  meta = {
    description = "Collection of GTSAM factors and optimizers for point cloud SLAM";
    homepage = "https://github.com/koide3/gtsam_points";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.omgbebebe ];
    platforms = lib.platforms.linux;
  };
}
