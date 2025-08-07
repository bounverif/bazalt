#!/usr/bin/env bash
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_PROTOBUF_VERSION=6.31.1 protobuf-source-install.sh

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

BAZALT_PROTOBUF_VERSION="${BAZALT_PROTOBUF_VERSION:-"3.21.12"}"
BAZALT_PROTOBUF_SOURCE_DIR="/tmp/bazalt/protobuf"
BAZALT_PROTOBUF_BUILD_DIR="/tmp/build/protobuf"
BAZALT_PROTOBUF_WITH_ZLIB="${BAZALT_PROTOBUF_WITH_ZLIB:-"OFF"}"
BAZALT_PROTOBUF_BUILD_PROTOC_BINARIES="${BAZALT_PROTOBUF_BUILD_PROTOC_BINARIES:-"ON"}"
BAZALT_PROTOBUF_BUILD_LIBPROTOC="${BAZALT_PROTOBUF_BUILD_LIBPROTOC:-"ON"}"
BAZALT_PROTOBUF_GIT_URL="https://github.com/protocolbuffers/protobuf"
BAZALT_PROTOBUF_BUILD_SHARED_LIBS="${BAZALT_PROTOBUF_BUILD_SHARED_LIBS:-"ON"}"
BAZALT_PROTOBUF_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:-"/opt/bazalt"}"
BAZALT_PROTOBUF_INSTALL_LIBDIR="${BAZALT_INSTALL_LIBDIR:-"lib"}"

echo "Cloning Protobuf version ${BAZALT_PROTOBUF_VERSION}..."

if [ ! -d "${BAZALT_PROTOBUF_SOURCE_DIR}" ]; then
  git clone "${BAZALT_PROTOBUF_GIT_URL}" "${BAZALT_PROTOBUF_SOURCE_DIR}" \
    --depth 1 \
    --branch "v${BAZALT_PROTOBUF_VERSION}" \
    --recurse-submodules

  if [ -f "${SCRIPT_DIR}/protobuf-patch.${BAZALT_PROTOBUF_VERSION}" ]; then
    patch -p1 -d "${BAZALT_PROTOBUF_SOURCE_DIR}" < "${SCRIPT_DIR}/protobuf-patch.${BAZALT_PROTOBUF_VERSION}"
    echo "Applied patches for Protobuf version ${BAZALT_PROTOBUF_VERSION}."
  fi
fi

cmake \
  -S "${BAZALT_PROTOBUF_SOURCE_DIR}" \
  -B "${BAZALT_PROTOBUF_BUILD_DIR}" \
  -DBUILD_SHARED_LIBS="${BAZALT_PROTOBUF_BUILD_SHARED_LIBS}" \
  -Dprotobuf_BUILD_PROTOC_BINARIES="${BAZALT_PROTOBUF_BUILD_PROTOC_BINARIES}" \
  -Dprotobuf_BUILD_TESTS="OFF" \
  -Dprotobuf_BUILD_EXAMPLES="OFF" \
  -Dprotobuf_WITH_ZLIB="${BAZALT_PROTOBUF_WITH_ZLIB}" \
  -Dprotobuf_INSTALL="ON" \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_PROTOBUF_INSTALL_PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR="${BAZALT_PROTOBUF_INSTALL_LIBDIR}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_PROTOBUF_BUILD_DIR}" --target install

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_PROTOBUF_SOURCE_DIR}" "${BAZALT_PROTOBUF_BUILD_DIR}"

echo "Protobuf ${BAZALT_PROTOBUF_VERSION} installed successfully to ${BAZALT_PROTOBUF_INSTALL_PREFIX}."
