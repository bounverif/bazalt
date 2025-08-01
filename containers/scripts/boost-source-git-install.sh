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
BAZALT_BOOST_TMPDIR="${BAZALT_BOOST_TMPDIR:=/tmp/bazalt/boost}"
BAZALT_BOOST_GIT_URL="${BAZALT_BOOST_GIT_URL:=https://github.com/boostorg/boost.git}"

BAZALT_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:=/usr/local}"

# Clone Boost repository
echo "Cloning Boost ${BAZALT_BOOST_VERSION}..."
git clone -j"$(nproc)" --recursive --depth 1 \
  --branch "boost-${BAZALT_BOOST_VERSION}" \
  "${BAZALT_BOOST_GIT_URL}" \
  "${BAZALT_BOOST_TMPDIR}"

# Build and install Boost
cd "${BAZALT_BOOST_TMPDIR}"

# Record version info if possible
if [ -d /etc/bazalt ]; then
  git tag --points-at HEAD >> /etc/bazalt/version || true
fi

echo "Configuring Boost..."
./bootstrap.sh --prefix="${BAZALT_INSTALL_PREFIX}" --without-libraries=python

echo "Building and installing Boost..."
./b2 link=static cxxflags=-fPIC cflags=-fPIC -j"$(nproc)" install

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "${BAZALT_BOOST_TMPDIR}"

echo "Boost ${BAZALT_BOOST_VERSION} installed successfully to ${BAZALT_INSTALL_PREFIX}."
