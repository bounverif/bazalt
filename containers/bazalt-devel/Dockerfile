ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt
ARG BAZALT_IMAGE_NAME_FULL=${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}
ARG BAZALT_IMAGE_VERSION=${BAZALT_VERSION}
ARG BAZALT_BUILDER_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-builder
ARG BAZALT_DEVEL_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-devel

# Packaged dependencies
ARG BAZALT_BUILD_BOOST_VERSION=1.88.0
ARG BAZALT_BUILD_ZENOH_VERSION=1.3.3
ARG BAZALT_BUILD_PROTOBUF_VERSION=3.21.12
FROM ${BAZALT_IMAGE_REGISTRY_REMOTE}/bazalt-boost:${BAZALT_BUILD_BOOST_VERSION}-devel AS bazalt-boost
FROM ${BAZALT_IMAGE_REGISTRY_REMOTE}/bazalt-protobuf:${BAZALT_BUILD_PROTOBUF_VERSION}-devel AS bazalt-protobuf
FROM ${BAZALT_IMAGE_REGISTRY_REMOTE}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-devel AS bazalt-zenoh

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


ARG BAZALT_BUILD_BOOST_VERSION
ENV BAZALT_BUILD_BOOST_VERSION=${BAZALT_BUILD_BOOST_VERSION}
COPY --from=bazalt-boost /usr/local/ /usr/local/

ARG BAZALT_BUILD_PROTOBUF_VERSION
ENV BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION}
COPY --from=bazalt-protobuf /usr/local/ /usr/local/

ARG BAZALT_BUILD_ZENOH_VERSION
ENV BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION}
# COPY --from=bazalt-zenoh /usr/local/ /usr/local/

# Install Zenoh from Debian repository
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    echo "deb [trusted=yes] https://download.eclipse.org/zenoh/debian-repo/ /" | tee -a /etc/apt/sources.list.d/zenoh.list > /dev/null &&\
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      libzenohc=${BAZALT_BUILD_ZENOH_VERSION} \
      libzenohpico=${BAZALT_BUILD_ZENOH_VERSION} \
      libzenohc-dev=${BAZALT_BUILD_ZENOH_VERSION} \
      libzenohpico-dev=${BAZALT_BUILD_ZENOH_VERSION} \
      libzenohcpp-dev=${BAZALT_BUILD_ZENOH_VERSION} \
      zenoh=${BAZALT_BUILD_ZENOH_VERSION} \
      zenoh-plugin-rest=${BAZALT_BUILD_ZENOH_VERSION} \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      libsystemd-dev \
      libspdlog-dev \
      libnanopb-dev \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

FROM ${BAZALT_BUILDER_IMAGE} AS bazalt-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      sudo \
      git \
      openssh-client \
      clangd \
      clang-format \
      clang-tidy \
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
WORKDIR /home/${USERNAME}

RUN python3 -m pip install --user --break-system-packages --no-cache-dir \
      pre-commit \
      cmakelang[YAML] \
      && \
    rm -rf /home/${USERNAME}/.cache/pip

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      sudo \
      systemd \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY systemd/system/* /etc/systemd/system/

CMD ["/lib/systemd/systemd"]
