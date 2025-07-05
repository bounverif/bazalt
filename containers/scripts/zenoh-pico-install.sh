#!/bin/sh -e
#
BAZALT_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}
BAZALT_BUILD_INSTALL_PREFIX=${BAZALT_BUILD_INSTALL_PREFIX:-${BAZALT_INSTALL_PREFIX}}
BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION:-latest}
BAZALT_BUILD_ZENOH_PICO_SOURCE_DIR="/tmp/zenoh-pico"
BAZALT_BUILD_ZENOH_PICO_BUILD_DIR="/tmp/build/zenoh-pico"
BAZALT_BUILD_ZENOH_PICO_SOURCE_REPOSITORY_URL="https://github.com/eclipse-zenoh/zenoh-pico"
BAZALT_BUILD_ZENOH_PICO_BUILD_STATIC_LIBS=ON
BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS=OFF

clone(){
  if [ "${BAZALT_BUILD_ZENOH_VERSION}" = "latest" ]; then
      BAZALT_BUILD_ZENOH_VERSION="$(curl -s https://api.github.com/repos/eclipse-zenoh/zenoh-pico/releases/latest | jq -r .tag_name)";
  fi
  echo "Cloning Zenoh-Pico version ${BAZALT_BUILD_ZENOH_VERSION}..."
  git clone "${BAZALT_BUILD_ZENOH_PICO_SOURCE_REPOSITORY_URL}" "${BAZALT_BUILD_ZENOH_PICO_SOURCE_DIR}" \
    --depth 1 \
    --branch "${BAZALT_BUILD_ZENOH_VERSION}"
}

build_install(){
cmake \
  -S "${BAZALT_BUILD_ZENOH_PICO_SOURCE_DIR}/${_ZENOH_PICO_SOURCE_CMAKELISTS_DIR}" \
  -B "${BAZALT_BUILD_ZENOH_PICO_BUILD_DIR}" \
  -DPICO_SHARED=${BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS} \
  -DPICO_STATIC=${BAZALT_BUILD_ZENOH_PICO_BUILD_STATIC_LIBS} \
  -DBUILD_SHARED_LIBS=${BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS} \
  -DBUILD_TESTING=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_TOOLS=OFF \
  -DBUILD_INTEGRATION=OFF \
  -DPACKAGING=OFF \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_BUILD_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build ${BAZALT_BUILD_ZENOH_PICO_BUILD_DIR} --target install
}

build_install_shared(){
  build_install
  mv "${BAZALT_BUILD_INSTALL_PREFIX}/lib/libzenohpico.so" "${BAZALT_BUILD_INSTALL_PREFIX}/lib/libzenohpico.so.${BAZALT_BUILD_ZENOH_VERSION}"
  cd "${BAZALT_BUILD_INSTALL_PREFIX}/lib" && ln -s "libzenoh-pico.so.${BAZALT_BUILD_ZENOH_VERSION}" libzenohpico.so
}

cleanup(){
  rm -rf ${BAZALT_BUILD_ZENOH_PICO_SOURCE_DIR} ${BAZALT_BUILD_ZENOH_PICO_BUILD_DIR}
}

runtime(){
  BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS=ON
  BAZALT_BUILD_ZENOH_PICO_BUILD_STATIC_LIBS=OFF
  clone
  build_install_shared
  cleanup
}

devel(){
  BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS=OFF
  BAZALT_BUILD_ZENOH_PICO_BUILD_STATIC_LIBS=ON
  clone
  build_install
  cleanup
}

all(){
  BAZALT_BUILD_ZENOH_PICO_BUILD_SHARED_LIBS=ON
  BAZALT_BUILD_ZENOH_PICO_BUILD_STATIC_LIBS=ON
  clone
  build_install_shared
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
