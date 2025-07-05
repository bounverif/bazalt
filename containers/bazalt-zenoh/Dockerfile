ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt

ARG BAZALT_BUILD_ZENOH_VERSION=latest
ARG BAZALT_BUILD_ZENOH_CPP_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
ARG BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
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
      pkg-config \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Install rustup (Rust installer) and add to PATH
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Ensure the PATH is set correctly for future use
ENV PATH=$CARGO_HOME/bin:$PATH

# Optional: Pre-install common Rust components/tools
RUN rustup install stable && \
    rustup default stable && \
    rustup component add rustfmt clippy

ARG BAZALT_BUILD_ZENOH_VERSION
ENV BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION}

ARG BAZALT_BUILD_ZENOH_PICO_VERSION
ENV BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_PICO_VERSION}
COPY --chmod=755 scripts/zenoh-pico-install.sh /usr/local/bin/zenoh-pico-install.sh
RUN /usr/local/bin/zenoh-pico-install.sh devel

ARG BAZALT_BUILD_ZENOH_VERSION
ENV BAZALT_BUILD_ZENOH_CPP_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
COPY --chmod=755 scripts/zenoh-cpp-install.sh /usr/local/bin/zenoh-cpp-install.sh
RUN /usr/local/bin/zenoh-cpp-install.sh devel

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-zenoh-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

COPY --from=bazalt-zenoh-builder /usr/local/ /usr/local/

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-zenoh-release
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      ca-certificates \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    echo "deb [trusted=yes] https://download.eclipse.org/zenoh/debian-repo/ /" | tee -a /etc/apt/sources.list.d/zenoh.list > /dev/null && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      zenoh \
      zenohd \
      libzenohc \
      libzenohpico \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

FROM bazalt-zenoh-release AS bazalt-zenoh-release-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    echo "deb [trusted=yes] https://download.eclipse.org/zenoh/debian-repo/ /" | tee -a /etc/apt/sources.list.d/zenoh.list > /dev/null && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      libzenohc-dev \
      libzenohpico-dev \
      libzenohcpp-dev \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
