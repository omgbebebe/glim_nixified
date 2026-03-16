{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  eigen,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gtsam";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "borglab";
    repo = "gtsam";
    rev = "release/${version}";
    hash = "sha256-MO2qWMxU0E8egvgGI5/CdBe09DXpIW9W+wErWQs9XXs=";
  };

  patches = [];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    boost
    eigen
    zlib
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF"
    "-DGTSAM_BUILD_TESTS=OFF"
    "-DGTSAM_WITH_TBB=OFF"
    "-DGTSAM_USE_SYSTEM_EIGEN=ON"
    "-DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    # if use_boost
#    "-DGTSAM_USE_BOOST_FEATURES=OFF"
#    "-DGTSAM_ENABLE_BOOST_SERIALIZATION=OFF"
  ];

  meta = {
    description = "library of C++ classes that implement smoothing and mapping (SAM) in robotics and vision";
    homepage = "https://github.com/borglab/gtsam";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.omgbebebe ];
    platforms = lib.platforms.linux;
  };
}
