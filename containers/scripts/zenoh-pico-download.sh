#!/bin/bash -e

BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_PICO_VERSION:-1.2.1}
BAZALT_BUILD_ZENOH_PICO_RELEASE_URL_PREFIX=https://github.com/eclipse-zenoh/zenoh-pico/releases/download
if [ "$TARGETARCH" = "amd64" ]; then
    BAZALT_BUILD_ZENOH_ARCH="x64";
elif [ "$TARGETARCH" = "arm64" ]; then
    BAZALT_BUILD_ZENOH_ARCH="arm64";
fi
BAZALT_BUILD_ZENOH_PICO_RELEASE_FILENAME=zenoh-pico-${BAZALT_BUILD_ZENOH_PICO_VERSION}-linux-${BAZALT_BUILD_ZENOH_ARCH}-standalone.zip

wget -q "${BAZALT_BUILD_ZENOH_PICO_RELEASE_URL_PREFIX}/${BAZALT_BUILD_ZENOH_PICO_VERSION}/${BAZALT_BUILD_ZENOH_PICO_RELEASE_FILENAME}" -O /tmp/zenoh-pico.zip
unzip /tmp/zenoh-pico.zip -d /usr/local/ 
mv /usr/local/lib/libzenohpico.so "/usr/local/lib/libzenohpico.so.${BAZALT_BUILD_ZENOH_PICO_VERSION}"
ln -s "/usr/local/lib/libzenoh-pico.so.${BAZALT_BUILD_ZENOH_PICO_VERSION}" /usr/local/lib/libzenohpico.so
rm /tmp/zenoh-pico.zip
