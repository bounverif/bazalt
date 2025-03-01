ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_NAME=bazalt
ARG BAZALT_IMAGE_VERSION=${BAZALT_VERSION}
ARG BAZALT_BUILDER_IMAGE=${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_IMAGE_VERSION}-builder
ARG BAZALT_DEVEL_IMAGE=${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_IMAGE_VERSION}-devel

ARG BAZALT_BUILD_ZENOH_VERSION=1.2.1
ARG BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
ARG BAZALT_BUILD_PROTOBUF_VERSION=3.21.12

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-downloader
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

# Install predependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      wget \
      unzip \
      git-core \
      jq \
      gnupg2 \
      ca-certificates \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 

ARG BAZALT_BUILD_ZENOH_PICO_VERSION
ENV BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_PICO_VERSION}

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        export BAZALT_BUILD_ZENOH_ARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        export BAZALT_BUILD_ZENOH_ARCH="arm64"; \
    fi && \
    wget -q https://github.com/eclipse-zenoh/zenoh-pico/releases/download/${BAZALT_BUILD_ZENOH_PICO_VERSION}/zenoh-pico-${BAZALT_BUILD_ZENOH_PICO_VERSION}-linux-${BAZALT_BUILD_ZENOH_ARCH}-standalone.zip -O /tmp/zenoh-pico.zip && \
    unzip /tmp/zenoh-pico.zip -d /tmp/zenoh-pico && \
    mv /tmp/zenoh-pico/include /usr/local && \
    mv /tmp/zenoh-pico/lib /usr/local && \
    rm /tmp/zenoh-pico.zip && \
    rm -rf /tmp/zenoh-pico

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      curl \
      wget \
      tar \
      unzip \
      gnupg2 \
      ca-certificates \
      git-core \
      build-essential \
      ninja-build \
      cmake \
      pkg-config \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG BAZALT_BUILD_PROTOBUF_VERSION
ENV BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION}
COPY --chmod=755 scripts/protobuf-install.sh /usr/local/bin/protobuf-install.sh
RUN /usr/local/bin/protobuf-install.sh devel

ARG BAZALT_BUILD_ZENOH_PICO_VERSION
ENV BAZALT_BUILD_ZENOH_PICO_VERSION=${BAZALT_BUILD_ZENOH_PICO_VERSION}
COPY --chmod=755 scripts/zenoh-pico-install.sh /usr/local/bin/zenoh-pico-install.sh
RUN /usr/local/bin/zenoh-pico-install.sh devel

ARG BAZALT_BUILD_SPDLOG_VERSION
ENV BAZALT_BUILD_SPDLOG_VERSION=${BAZALT_BUILD_SPDLOG_VERSION}
COPY --chmod=755 scripts/spdlog-install.sh /usr/local/bin/spdlog-install.sh
RUN /usr/local/bin/spdlog-install.sh

FROM ${BAZALT_BUILDER_IMAGE} AS bazalt-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      sudo \
      clangd \
      clang-format \
      clang-tidy \
      pre-commit \
      python3-minimal \
      python3-pip \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Add a container user (good practice)
ARG USERNAME=nonroot
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid ${USER_GID} $USERNAME &&\
    useradd -ms /bin/bash ${USERNAME} --uid $USER_UID --gid $USER_GID &&\
    echo "${USERNAME}:${USERNAME}" | chpasswd &&\
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} &&\
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      systemd \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY --from=bazalt-builder /usr/local/lib/*.so /usr/local/lib/