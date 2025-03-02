ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt-protobuf

ARG BAZALT_BUILD_PROTOBUF_VERSION=latest

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-protobuf-builder
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

ARG BAZALT_BUILD_PROTOBUF_VERSION
ENV BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION}
COPY --chmod=755 scripts/protobuf-install.sh /usr/local/bin/protobuf-install.sh
RUN /usr/local/bin/protobuf-install.sh devel

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-protobuf-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

COPY --from=bazalt-protobuf-builder /usr/local/ /usr/local/
