{
  description = "ZMK keyboard firmware development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ZMK dependencies
            python3
            python3Packages.west
            python3Packages.pip
            python3Packages.setuptools
            python3Packages.wheel
            cmake
            ninja
            dtc
            
            # Build tools
            gcc-arm-embedded
            
            # Additional Zephyr dependencies
            python3Packages.pyyaml
            python3Packages.canopen
            python3Packages.packaging
            python3Packages.progress
            python3Packages.psutil
            python3Packages.pyelftools
            python3Packages.pykwalify
            python3Packages.pyserial
            python3Packages.colorama
            python3Packages.pillow
            python3Packages.intelhex
            python3Packages.requests
            python3Packages.anytree
            
            # Optional utilities
            git
          ];

          shellHook = ''
            export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
            export GNUARMEMB_TOOLCHAIN_PATH="${pkgs.gcc-arm-embedded}"
            export ZEPHYR_BASE="$PWD/zephyr"
            export KCONFIG_WARN_UNDEF=n
            export KCONFIG_WARN_UNDEF_ASSIGN=n
            echo "ZMK development environment ready"
            echo "Run 'west init -l config/' to initialize (first time only)"
            echo "Run 'west update' to fetch dependencies"
            echo "Run 'west build -p -b nice_nano_v2 -- -DSHIELD=corne_left' to build"
          '';
        };
      });
}