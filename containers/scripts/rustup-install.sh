#!/usr/bin/env bash
#
# Example Usage:
# BAZALT_INSTALL_PREFIX=/tmp/install rustup-install.sh

# Ensure prerequisites are installed
if ! command -v curl >/dev/null 2>&1; then
  echo "Error: 'curl' is required but not installed. Please install curl and try again." >&2
  exit 1
fi

BAZALT_RUST_INSTALL_PREFIX="${BAZALT_INSTALL_PREFIX:-/usr/local}"

mkdir -p "${BAZALT_RUST_INSTALL_PREFIX}/bin"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o "${BAZALT_RUST_INSTALL_PREFIX}/bin/rustup-init"
chmod +x "${BAZALT_RUST_INSTALL_PREFIX}/bin/rustup-init"

echo "Rustup $("${BAZALT_RUST_INSTALL_PREFIX}"/bin/rustup-init --version) installed successfully to ${BAZALT_RUST_INSTALL_PREFIX}."
