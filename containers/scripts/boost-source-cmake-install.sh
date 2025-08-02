#!/bin/bash -ex
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install BAZALT_BOOST_VERSION=1.88.0 boost-source-install.sh

# Ensure prerequisites are installed
if ! command -v git >/dev/null 2>&1; then
  echo "Error: 'git' is required but not installed. Please install git and try again." >&2
  exit 1
fi

# Set default values for Boost build configuration
BAZALT_BOOST_VERSION="${BAZALT_BOOST_VERSION:="1.88.0"}"
BAZALT_BOOST_SOURCE_DIR="${BAZALT_BOOST_SOURCE_DIR:=/tmp/bazalt/boost}"
BAZALT_BOOST_BUILD_DIR="${BAZALT_BOOST_BUILD_DIR:=/tmp/build/boost}"
BAZALT_BOOST_CMAKE_RELEASE_URL="${BAZALT_BOOST_CMAKE_RELEASE_URL:=https://github.com/boostorg/boost/releases/download/boost-${BAZALT_BOOST_VERSION}/boost-${BAZALT_BOOST_VERSION}-cmake.tar.gz}"
BAZALT_BOOST_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:=/usr/local}"

# Get Boost CMake release tarball
mkdir -p "${BAZALT_BOOST_SOURCE_DIR}"
curl -L "${BAZALT_BOOST_CMAKE_RELEASE_URL}" | tar -xz --strip-components=1 -C "${BAZALT_BOOST_SOURCE_DIR}"

# Build and install Boost
cd "${BAZALT_BOOST_SOURCE_DIR}"

# -DBOOST_INCLUDE_LIBRARIES="chrono;container;json;program_options;url"
cmake \
  -S "${BAZALT_BOOST_SOURCE_DIR}" \
  -B "${BAZALT_BOOST_BUILD_DIR}" \
  -DBUILD_SHARED_LIBS=OFF \
  -DBOOST_ENABLE_MPI=OFF \
  -DBOOST_ENABLE_PYTHON=OFF \
  -DCMAKE_INSTALL_PREFIX="${BAZALT_BOOST_INSTALL_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build "${BAZALT_BOOST_BUILD_DIR}" --target install -- -j"$(nproc)"

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_BOOST_SOURCE_DIR}" "${BAZALT_BOOST_BUILD_DIR}"

echo "Boost ${BAZALT_BOOST_VERSION} installed successfully to ${BAZALT_BOOST_INSTALL_PREFIX}."
