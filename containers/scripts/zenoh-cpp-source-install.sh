#!/usr/bin/env bash
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_ZENOH_VERSION=1.5.0 zenoh-cpp-source-install.sh

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
BAZALT_ZENOH_CPP_VERSION="${BAZALT_ZENOH_VERSION}"
BAZALT_ZENOH_CPP_SOURCE_DIR="/tmp/bazalt/zenoh-cpp"
BAZALT_ZENOH_CPP_BUILD_DIR="/tmp/build/zenoh-cpp"
BAZALT_ZENOH_CPP_GIT_URL="https://github.com/eclipse-zenoh/zenoh-cpp"
BAZALT_ZENOH_CPP_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:-"/opt/bazalt"}"
BAZALT_ZENOH_CPP_INSTALL_LIBDIR="${BAZALT_INSTALL_LIBDIR:-"lib"}"

echo "Cloning zenoh-cpp version ${BAZALT_ZENOH_CPP_VERSION}..."
git clone "${BAZALT_ZENOH_CPP_GIT_URL}" "${BAZALT_ZENOH_CPP_SOURCE_DIR}" \
  --depth 1 \
  --branch "${BAZALT_ZENOH_CPP_VERSION}"

cmake \
  -S "${BAZALT_ZENOH_CPP_SOURCE_DIR}" \
  -B "${BAZALT_ZENOH_CPP_BUILD_DIR}" \
  -DZENOHCXX_EXAMPLES_PROTOBUF=OFF \
  -DZENOHCXX_ENABLE_TESTS=OFF \
  -DZENOHCXX_ENABLE_EXAMPLES=OFF \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_ZENOH_CPP_INSTALL_PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR="${BAZALT_ZENOH_CPP_INSTALL_LIBDIR}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build ${BAZALT_ZENOH_CPP_BUILD_DIR} --target install

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_ZENOH_CPP_SOURCE_DIR}" "${BAZALT_ZENOH_CPP_BUILD_DIR}"

echo "Zenoh ${BAZALT_ZENOH_CPP_VERSION} installed successfully to ${BAZALT_ZENOH_CPP_INSTALL_PREFIX}."
