#!/usr/bin/env bash
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_ZENOH_VERSION=1.5.0 zenoh-c-source-install.sh

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Ensure prerequisites are installed
if ! command -v git >/dev/null 2>&1; then
  echo "Error: 'git' is required but not installed. Please install git and try again." >&2
  exit 1
fi
if ! command -v cmake >/dev/null 2>&1; then
  echo "Error: 'cmake' is required but not installed. Please install cmake and try again." >&2
  exit 1
fi

BAZALT_ZENOH_VERSION="${BAZALT_ZENOH_VERSION:-"1.5.0"}"
BAZALT_ZENOH_C_VERSION="${BAZALT_ZENOH_VERSION}"
BAZALT_ZENOH_C_SOURCE_DIR="/tmp/bazalt/zenoh-c"
BAZALT_ZENOH_C_BUILD_DIR="/tmp/build/zenoh-c"
BAZALT_ZENOH_C_GIT_URL="https://github.com/eclipse-zenoh/zenoh-c"
BAZALT_ZENOH_C_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:-"/opt/bazalt"}"
BAZALT_ZENOH_C_INSTALL_LIBDIR="${BAZALT_INSTALL_LIBDIR:-"lib"}"

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
  -DCMAKE_INSTALL_LIBDIR="${BAZALT_ZENOH_C_INSTALL_LIBDIR}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_ZENOH_C_BUILD_DIR}" --target install

mv "${BAZALT_ZENOH_C_INSTALL_PREFIX}/${BAZALT_ZENOH_C_INSTALL_LIBDIR}/libzenohc.so" "${BAZALT_ZENOH_C_INSTALL_PREFIX}/${BAZALT_ZENOH_C_INSTALL_LIBDIR}/libzenohc.so.${BAZALT_ZENOH_C_VERSION}"
cd "${BAZALT_ZENOH_C_INSTALL_PREFIX}/${BAZALT_ZENOH_C_INSTALL_LIBDIR}" && ln -sf "libzenohc.so.${BAZALT_ZENOH_C_VERSION}" "libzenohc.so" && cd "${SCRIPT_DIR}"

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_ZENOH_C_SOURCE_DIR}" "${BAZALT_ZENOH_C_BUILD_DIR}"

echo "Zenoh ${BAZALT_ZENOH_C_VERSION} installed successfully to ${BAZALT_ZENOH_C_INSTALL_PREFIX}."
