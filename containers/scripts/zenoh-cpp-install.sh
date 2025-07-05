#!/bin/sh -e
#
BAZALT_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}
BAZALT_BUILD_INSTALL_PREFIX=${BAZALT_BUILD_INSTALL_PREFIX:-${BAZALT_INSTALL_PREFIX}}
BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION:-latest}
BAZALT_BUILD_ZENOH_CPP_SOURCE_DIR="/tmp/zenoh-cpp"
BAZALT_BUILD_ZENOH_CPP_BUILD_DIR="/tmp/build/zenoh-cpp"
BAZALT_BUILD_ZENOH_CPP_SOURCE_REPOSITORY_URL="https://github.com/eclipse-zenoh/zenoh-cpp"

clone(){
  if [ "${BAZALT_BUILD_ZENOH_VERSION}" = "latest" ]; then
      BAZALT_BUILD_ZENOH_VERSION="$(curl -s https://api.github.com/repos/eclipse-zenoh/zenoh-cpp/releases/latest | jq -r .tag_name)";
  fi
  echo "Cloning zenoh-cpp version ${BAZALT_BUILD_ZENOH_VERSION}..."
  git clone "${BAZALT_BUILD_ZENOH_CPP_SOURCE_REPOSITORY_URL}" "${BAZALT_BUILD_ZENOH_CPP_SOURCE_DIR}" \
    --depth 1 \
    --branch "${BAZALT_BUILD_ZENOH_VERSION}"
}

build_install(){
cmake \
  -S "${BAZALT_BUILD_ZENOH_CPP_SOURCE_DIR}" \
  -B "${BAZALT_BUILD_ZENOH_CPP_BUILD_DIR}" \
  -DZENOHCXX_ZENOHC=OFF \
  -DZENOHCXX_ZENOHPICO=ON \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_BUILD_INSTALL_PREFIX}"
cmake --build ${BAZALT_BUILD_ZENOH_CPP_BUILD_DIR} --target install
}

cleanup(){
  rm -rf ${BAZALT_BUILD_ZENOH_CPP_SOURCE_DIR} ${BAZALT_BUILD_ZENOH_CPP_BUILD_DIR}
}

devel(){
  clone
  build_install
  cleanup
}

all(){
  devel
}

# Handle script arguments dynamically
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 {devel|all}"
  exit 1
fi

for arg in "$@"; do
  case "$arg" in
    devel) devel ;;
    all) all ;;
    *) echo "Invalid argument: $arg"; exit 1 ;;
  esac
done
