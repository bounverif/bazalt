ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt

ARG BAZALT_BUILD_ZENOH_VERSION=latest
ARG BAZALT_IMAGE_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION}

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-zenoh-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      curl \
      wget \
      tar \
      unzip \
      jq \
      gnupg2 \
      ca-certificates \
      git-core \
      build-essential \
      cmake \
      ninja-build \
      python3-minimal \
      python3-pip \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG BAZALT_BUILD_ZENOH_VERSION
ENV BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
COPY --chmod=755 scripts/zenoh-pico-install.sh /usr/local/bin/zenoh-pico-install.sh
RUN /usr/local/bin/zenoh-pico-install.sh devel

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-zenoh-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

COPY --from=bazalt-zenoh-builder /usr/local/lib/ /usr/local/lib/
COPY --from=bazalt-zenoh-builder /usr/local/include/ /usr/local/include/
