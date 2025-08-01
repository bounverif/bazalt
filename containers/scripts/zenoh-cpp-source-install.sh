#!/bin/bash -ex
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_ZENOH_VERSION=1.5.0 zenoh-cpp-source-install.sh

BAZALT_ZENOH_VERSION=${BAZALT_ZENOH_VERSION:-1.5.0}
BAZALT_ZENOH_CPP_SOURCE_DIR="/tmp/bazalt/zenoh-cpp"
BAZALT_ZENOH_CPP_BUILD_DIR="/tmp/build/zenoh-cpp"
BAZALT_ZENOH_CPP_GIT_URL="https://github.com/eclipse-zenoh/zenoh-cpp"

BAZALT_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}

echo "Cloning zenoh-cpp version ${BAZALT_ZENOH_VERSION}..."
git clone "${BAZALT_ZENOH_CPP_GIT_URL}" "${BAZALT_ZENOH_CPP_SOURCE_DIR}" \
  --depth 1 \
  --branch "${BAZALT_ZENOH_VERSION}"

cmake \
  -S "${BAZALT_ZENOH_CPP_SOURCE_DIR}" \
  -B "${BAZALT_ZENOH_CPP_BUILD_DIR}" \
  -DZENOHCXX_EXAMPLES_PROTOBUF=OFF \
  -DZENOHCXX_ENABLE_TESTS=OFF \
  -DZENOHCXX_ENABLE_EXAMPLES=OFF \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX}"
cmake --build ${BAZALT_ZENOH_CPP_BUILD_DIR} --target install

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_ZENOH_CPP_SOURCE_DIR}" "${BAZALT_ZENOH_CPP_BUILD_DIR}"

echo "Zenoh ${BAZALT_ZENOH_VERSION} installed successfully to ${BAZALT_INSTALL_PREFIX}."d
