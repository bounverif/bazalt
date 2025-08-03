#!/bin/bash -ex
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_ZENOH_VERSION=1.5.0 zenoh-c-source-install.sh

BAZALT_ZENOH_VERSION=${BAZALT_ZENOH_VERSION:-1.5.0}
BAZALT_ZENOH_C_VERSION=${BAZALT_ZENOH_VERSION}
BAZALT_ZENOH_C_SOURCE_DIR="/tmp/bazalt/zenoh-c"
BAZALT_ZENOH_C_BUILD_DIR="/tmp/build/zenoh-c"
BAZALT_ZENOH_C_GIT_URL="https://github.com/eclipse-zenoh/zenoh-c"
BAZALT_ZENOH_C_INSTALL_PREFIX=${BAZALT_INSTALL_PREFIX:-/usr/local}

echo "Cloning Zenoh version ${BAZALT_ZENOH_C_VERSION}..."
git clone "${BAZALT_ZENOH_C_GIT_URL}" "${BAZALT_ZENOH_C_SOURCE_DIR}" \
  --depth 1 \
  --branch "${BAZALT_ZENOH_C_VERSION}" \
  --recurse-submodules

cmake \
  -S "${BAZALT_ZENOH_C_SOURCE_DIR}" \
  -B "${BAZALT_ZENOH_C_BUILD_DIR}" \
  -DBUILD_SHARED_LIBS=ON \
  -DZENOHC_BUILD_WITH_SHARED_MEMORY=ON \
  -DZENOHC_BUILD_WITH_UNSTABLE_API=OFF \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_ZENOH_C_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_ZENOH_C_BUILD_DIR}" --target install

mv "${BAZALT_ZENOH_C_INSTALL_PREFIX}/lib64/libzenohc.so" "${BAZALT_ZENOH_C_INSTALL_PREFIX}/lib64/libzenohc.so.${BAZALT_ZENOH_C_VERSION}"
ln -sf "libzenohc.so.${BAZALT_ZENOH_C_VERSION}" "${BAZALT_ZENOH_C_INSTALL_PREFIX}/lib64/libzenohc.so"

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_ZENOH_C_SOURCE_DIR}" "${BAZALT_ZENOH_C_BUILD_DIR}"

echo "Zenoh ${BAZALT_ZENOH_C_VERSION} installed successfully to ${BAZALT_ZENOH_C_INSTALL_PREFIX}."
