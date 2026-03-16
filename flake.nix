{
  inputs = {
#    nixpkgs.url = "github:nixos/nixpkgs/25.11";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
#    nix-ros-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = { self, nix-ros-overlay, nixpkgs, flake-parts, ... }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        gtsam = pkgs.callPackage ./gtsam.nix { };
        gtsam_points = pkgs.callPackage ./gtsam_points.nix { gtsam = gtsam; };
        iridescence = pkgs.callPackage ./iridescence.nix { };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
        glim-src = pkgs.fetchFromGitHub {
          owner = "koide3";
          repo = "glim";
          rev = "25ad190776f05f6a8d7438686197294f73c5f868";
          hash = "sha256-bZ+teKYRmzro4/WwVo+Rpt366j0bB7c/JH0DEKVMRy4=";
        };
        glim_ros2-src = pkgs.fetchFromGitHub {
          owner = "koide3";
          repo = "glim_ros2";
          rev = "a62811dc3ab73076f4a43fc21005f96cd712903c";
          hash = "sha256-axbZxzQ6HsXRMBgCfZLjh9w5Y2LdELPWWS9aDTHUIz0=";
        };
      in {
        devShells.default = pkgs.mkShell rec {
          name = "Example project";
          packages = (with pkgs; [
            colcon
            libGL glfw
            libjpeg libpng
            opencv
            fmt spdlog
            gtsam
            gtsam_points
            iridescence
#            pkgs.cmake pkgs.pkg-config
            # ... other non-ROS packages
#            (with pkgs.rosPackages.humble; buildEnv {
            (with rosPackages.jazzy; buildEnv {
              paths = [
                geometry-msgs
                ros-base
                ament-cmake-core
                ament-index-cpp
                image-transport-plugins
                tf2-ros
                rosbag2-cpp
                rosbag2-compression
                rosbag2-storage
                #pcl pcl-ros
                # ... other ROS packages
              ];
            })
          ]);
          shellHook = ''
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath packages}";
            echo "ROS2 dev environment"
            #mkdir -p src
            #ln -s ${glim-src.out} src/glim
            #ln -s ${glim_ros2-src.out} src/glim_ros2
            rm -rf src
            mkdir -p src/{glim,glim_ros2}
            cp -RL ${glim-src.out}/* src/glim/
            cp -RL ${glim_ros2-src.out}/* src/glim_ros2/
            chmod -R +w src/
            # patch glim
            patch -p1 -i glim_0001.patch
            echo "use:"
            echo " colcon build --cmake-args -DBUILD_WITH_CUDA=OFF -DBUILD_WITH_VIEWER=OFF"
          '';
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
