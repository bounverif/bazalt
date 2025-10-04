#!/usr/bin/env bash
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_ICEORYX2_VERSION=1.5.0 iceoryx2-source-install.sh

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

BAZALT_ICEORYX2_VERSION="${BAZALT_ICEORYX2_VERSION:-"0.7.0"}"
BAZALT_ICEORYX2_SOURCE_DIR="/tmp/bazalt/iceoryx2"
BAZALT_ICEORYX2_BUILD_DIR="/tmp/build/iceoryx2"
BAZALT_ICEORYX2_GIT_URL="https://github.com/eclipse-iceoryx/iceoryx2"
BAZALT_ICEORYX2_GIT_TAG="v${BAZALT_ICEORYX2_VERSION}"
BAZALT_ICEORYX2_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:-"/opt/bazalt"}"
BAZALT_ICEORYX2_INSTALL_LIBDIR="${BAZALT_INSTALL_LIBDIR:-"lib"}"

echo "Cloning Zenoh version ${BAZALT_ICEORYX2_VERSION}..."
git clone "${BAZALT_ICEORYX2_GIT_URL}" "${BAZALT_ICEORYX2_SOURCE_DIR}" \
  --depth 1 \
  --branch "${BAZALT_ICEORYX2_GIT_TAG}" \
  --recurse-submodules

cmake \
  -S "${BAZALT_ICEORYX2_SOURCE_DIR}" \
  -B "${BAZALT_ICEORYX2_BUILD_DIR}" \
cmake --build "${BAZALT_ICEORYX2_BUILD_DIR}" --target install

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_ICEORYX2_SOURCE_DIR}" "${BAZALT_ICEORYX2_BUILD_DIR}"

echo "Iceoryx2 ${BAZALT_ICEORYX2_VERSION} installed successfully to ${BAZALT_ICEORYX2_INSTALL_PREFIX}."
