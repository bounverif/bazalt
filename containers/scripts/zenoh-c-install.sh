#!/bin/sh -e
#
BAZALT_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}
BAZALT_ZENOH_VERSION=${BAZALT_ZENOH_VERSION:-latest}
BAZALT_ZENOHC_SOURCE_DIR="/tmp/zenoh-c"
BAZALT_ZENOHC_BUILD_DIR="/tmp/build/zenoh-c"
BAZALT_ZENOHC_SOURCE_REPOSITORY_URL="https://github.com/eclipse-zenoh/zenoh-c"
BAZALT_ZENOHC_BUILD_STATIC_LIBS=ON
BAZALT_ZENOHC_BUILD_SHARED_LIBS=OFF

if uname -m | grep -q "x86_64"; then
  BAZALT_UNAME_ARCH="x86_64"
  BAZALT_DEBIAN_ARCH="amd64"
elif uname -m | grep -q "aarch64"; then
  BAZALT_UNAME_ARCH="aarch64"
  BAZALT_DEBIAN_ARCH="arm64"
else
  echo "Unsupported architecture: $(uname -m)"
  exit 1
fi

if uname -s | grep -q "Linux"; then
  BAZALT_SYSTEM="linux"
  BAZALT_UNAME_SYSTEM="Linux"
else
  echo "Unsupported system: $(uname -s)"
  exit 1
fi

clone(){
  if [ "${BAZALT_ZENOH_VERSION}" = "latest" ]; then
    BAZALT_ZENOH_VERSION="$(curl -s https://api.github.com/repos/eclipse-zenoh/zenoh-c/releases/latest | jq -r .tag_name)";
  fi
  echo "Cloning Zenohc version ${BAZALT_ZENOH_VERSION}..."
  git clone "${BAZALT_ZENOHC_SOURCE_REPOSITORY_URL}" "${BAZALT_ZENOHC_SOURCE_DIR}" \
    --depth 1 \
    --branch "${BAZALT_ZENOH_VERSION}"
}

build_install_static(){
cmake \
  -S "${BAZALT_ZENOHC_SOURCE_DIR}/${_ZENOHC_SOURCE_CMAKELISTS_DIR}" \
  -B "${BAZALT_ZENOHC_BUILD_DIR}" \
  -DBUILD_SHARED_LIBS=OFF \
  -DZENOHC_BUILD_WITH_SHARED_MEMORY=ON \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build ${BAZALT_ZENOHC_BUILD_DIR} --target install
}

build_install_shared(){
  cmake \
    -S "${BAZALT_ZENOHC_SOURCE_DIR}/${_ZENOHC_SOURCE_CMAKELISTS_DIR}" \
    -B "${BAZALT_ZENOHC_BUILD_DIR}" \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX}" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
  cmake --build ${BAZALT_ZENOHC_BUILD_DIR} --target install
  mv "${BAZALT_INSTALL_PREFIX}/lib/libzenohc.so" "${BAZALT_INSTALL_PREFIX}/lib/libzenohc.so.${BAZALT_ZENOH_VERSION}"
  cd "${BAZALT_INSTALL_PREFIX}/lib" && ln -s "libzenohc.so.${BAZALT_ZENOH_VERSION}" libzenohc.so
}

cleanup(){
  rm -rf ${BAZALT_ZENOHC_SOURCE_DIR} ${BAZALT_ZENOHC_BUILD_DIR}
}

runtime(){
  clone
  build_install_shared
  cleanup
}

devel(){
  clone
  build_install_shared
  build_install_static
  cleanup
}

all(){
  devel
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
