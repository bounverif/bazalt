#!/bin/bash -ex
#
# Example Usage: 
# BAZALT_BUILD_INSTALL_PREFIX=~/pb BAZALT_BUILD_PROTOBUF_VERSION=3.15.2 protobuf-install.sh all

BAZALT_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}
BAZALT_BUILD_INSTALL_PREFIX=${BAZALT_BUILD_INSTALL_PREFIX:-${BAZALT_INSTALL_PREFIX}}
BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION:-3.21.12}
BAZALT_BUILD_PROTOBUF_SOURCE_DIR="/tmp/protobuf"
BAZALT_BUILD_PROTOBUF_BUILD_DIR="/tmp/build/protobuf"
BAZALT_BUILD_PROTOBUF_WITH_ZLIB=${BAZALT_BUILD_PROTOBUF_WITH_ZLIB:-"OFF"}
BAZALT_BUILD_PROTOBUF_INSTALL=${BAZALT_BUILD_PROTOBUF_INSTALL:-"ON"}
BAZALT_BUILD_PROTOBUF_SOURCE_REPOSITORY_URL="https://github.com/protocolbuffers/protobuf"

# CMakeLists.txt moved from the cmake directory to the top-level in v3.21
PROTOBUF_SOURCE_CMAKELISTS_DIR=""
if dpkg --compare-versions "${BAZALT_BUILD_PROTOBUF_VERSION}" "lt" "3.21"; then
  PROTOBUF_SOURCE_CMAKELISTS_DIR="cmake"
fi

clone(){
  echo "Cloning Protobuf version ${BAZALT_BUILD_PROTOBUF_VERSION}..."
  git clone "${BAZALT_BUILD_PROTOBUF_SOURCE_REPOSITORY_URL}" "${BAZALT_BUILD_PROTOBUF_SOURCE_DIR}" \
    --depth 1 \
    --branch "v${BAZALT_BUILD_PROTOBUF_VERSION}" \
    --recurse-submodules
}

build-install-shared(){
  cmake \
  -S "${BAZALT_BUILD_PROTOBUF_SOURCE_DIR}/${PROTOBUF_SOURCE_CMAKELISTS_DIR}" \
  -B "${BAZALT_BUILD_PROTOBUF_BUILD_DIR}/shared" \
  -DBUILD_SHARED_LIBS=ON \
  -Dprotobuf_WITH_ZLIB="${BAZALT_BUILD_PROTOBUF_WITH_ZLIB}" \
  -Dprotobuf_BUILD_TESTS=OFF \
  -Dprotobuf_BUILD_EXAMPLES=OFF \
  -Dprotobuf_BUILD_PROTOC_BINARIES=OFF \
  -Dprotobuf_BUILD_LIBPROTOC=ON \
  -Dprotobuf_INSTALL="${BAZALT_BUILD_PROTOBUF_INSTALL}" \
  -Dprotobuf_FORCE_FETCH_DEPENDENCIES=ON \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_BUILD_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_BUILD_PROTOBUF_BUILD_DIR}/shared" --target install
}

build-install-static(){
  cmake \
  -S "${BAZALT_BUILD_PROTOBUF_SOURCE_DIR}/${PROTOBUF_SOURCE_CMAKELISTS_DIR}" \
  -B "${BAZALT_BUILD_PROTOBUF_BUILD_DIR}/static" \
  -DBUILD_SHARED_LIBS=OFF \
  -Dprotobuf_WITH_ZLIB="${BAZALT_BUILD_PROTOBUF_WITH_ZLIB}" \
  -Dprotobuf_BUILD_TESTS=OFF \
  -Dprotobuf_BUILD_EXAMPLES=OFF \
  -Dprotobuf_BUILD_PROTOC_BINARIES=OFF \
  -Dprotobuf_BUILD_LIBPROTOC=ON \
  -Dprotobuf_INSTALL="${BAZALT_BUILD_PROTOBUF_INSTALL}" \
  -Dprotobuf_FORCE_FETCH_DEPENDENCIES=ON \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_BUILD_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_BUILD_PROTOBUF_BUILD_DIR}/static" --target install
}

cleanup(){
  rm -rf "${BAZALT_BUILD_PROTOBUF_SOURCE_DIR}" "${BAZALT_BUILD_PROTOBUF_BUILD_DIR}"
}

runtime(){
  clone
  build-install-shared
  cleanup
}

devel(){
  clone
  build-install-static
  cleanup
}

all(){
  clone
  build-install-shared
  build-install-static
  cleanup
}

# Handle script arguments dynamically
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 {runtime|devel|all}"
  exit 1
fi

for arg in "$@"; do
  case "$arg" in
    runtime) runtime ;;
    devel) devel ;;
    all) all ;;
    *) echo "Invalid argument: $arg"; exit 1 ;;
  esac
done
