ARG BAZALT_VERSION=latest
ARG BAZALT_BASE_IMAGE=quay.io/pypa/manylinux_2_28

ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt
ARG BAZALT_IMAGE_NAME_FULL=${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}
ARG BAZALT_IMAGE_VERSION=${BAZALT_VERSION}
ARG BAZALT_BUILDER_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-builder
ARG BAZALT_DEVEL_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-devel

ARG BAZALT_BOOST_VERSION=1.88.0
ARG BAZALT_ZENOH_VERSION=1.5.0
ARG BAZALT_PROTOBUF_VERSION=6.31.1
ARG BAZALT_FLATBUFFERS_VERSION=25.2.10

FROM ${BAZALT_BASE_IMAGE} AS bazalt-builder-base
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN dnf install -y \
      curl \
      wget \
      tar \
      gzip \
      bzip2 \
      xz \
      unzip \
      git \
      make \
      cmake \
      patch \
      ninja-build \
      zlib-devel \
      openssl-devel \
      python3.11 \
      python3.11-pip \
      pkgconf-pkg-config \
      && \
    dnf clean all

ENV BAZALT_INSTALL_PREFIX="/opt/bazalt"
RUN mkdir -p ${BAZALT_INSTALL_PREFIX}

# Update environment paths for tools, headers, libraries, and build systems
ENV PATH="${BAZALT_INSTALL_PREFIX}/bin:${PATH}" \
    CPATH="${BAZALT_INSTALL_PREFIX}/include:${CPATH}" \
    LD_LIBRARY_PATH="${BAZALT_INSTALL_PREFIX}/lib:${LD_LIBRARY_PATH}" \
    PKG_CONFIG_PATH="${BAZALT_INSTALL_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"

FROM bazalt-builder-base AS bazalt-builder-boost
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
ARG BAZALT_BOOST_VERSION
ENV BAZALT_BOOST_VERSION=${BAZALT_BOOST_VERSION}
RUN --mount=type=bind,source=./scripts/boost-source-cmake-install.sh,target=/container-build/scripts/boost-source-cmake-install.sh \
    . /container-build/scripts/boost-source-cmake-install.sh

FROM bazalt-builder-base AS bazalt-builder-zenoh
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
ARG BAZALT_ZENOH_VERSION
ENV BAZALT_ZENOH_VERSION=${BAZALT_ZENOH_VERSION}
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"

RUN --mount=type=bind,source=./scripts/rustup-install.sh,target=/container-build/scripts/rustup-install.sh \
    . /container-build/scripts/rustup-install.sh && \
    rustup-init -y --default-toolchain none --profile minimal

RUN --mount=type=bind,source=./scripts/zenoh-c-source-install.sh,target=/container-build/scripts/zenoh-c-source-install.sh \
    --mount=type=bind,source=./scripts/zenoh-cpp-source-install.sh,target=/container-build/scripts/zenoh-cpp-source-install.sh \
    . /container-build/scripts/zenoh-c-source-install.sh && \
    . /container-build/scripts/zenoh-cpp-source-install.sh

FROM bazalt-builder-base AS bazalt-builder-protobuf
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
ARG BAZALT_PROTOBUF_VERSION
ENV BAZALT_PROTOBUF_VERSION=${BAZALT_PROTOBUF_VERSION}
RUN --mount=type=bind,source=./scripts/protobuf-source-install.sh,target=/container-build/scripts/protobuf-source-install.sh \
    --mount=type=bind,source=./scripts/protobuf-6.31.1.patch,target=/container-build/scripts/protobuf-6.31.1.patch \
    . /container-build/scripts/protobuf-source-install.sh

FROM bazalt-builder-base AS bazalt-builder-flatbuffers
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
ARG BAZALT_FLATBUFFERS_VERSION
ENV BAZALT_FLATBUFFERS_VERSION=${BAZALT_FLATBUFFERS_VERSION}

FROM bazalt-builder-base AS bazalt-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

# Copy installed files from all builder stages into the final image
COPY --from=bazalt-builder-boost       ${BAZALT_INSTALL_PREFIX}/ ${BAZALT_INSTALL_PREFIX}/
COPY --from=bazalt-builder-zenoh       ${BAZALT_INSTALL_PREFIX}/ ${BAZALT_INSTALL_PREFIX}/
COPY --from=bazalt-builder-protobuf    ${BAZALT_INSTALL_PREFIX}/ ${BAZALT_INSTALL_PREFIX}/
COPY --from=bazalt-builder-flatbuffers ${BAZALT_INSTALL_PREFIX}/ ${BAZALT_INSTALL_PREFIX}/

FROM bazalt-builder AS bazalt-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN dnf install -y \
      nano \
      && \
    dnf clean all

RUN python3 -m pip install --no-cache-dir pipx && \
    python3 -m pipx ensurepath && \
    python3 -m pipx install --pip-args="--no-cache-dir" \
      reuse \
      pre-commit \
      && \
    rm -rf /root/.cache /root/.local/share/pipx/.cache

FROM ghcr.io/almalinux/8-init AS bazalt-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG BAZALT_ZENOH_VERSION
ENV BAZALT_ZENOH_VERSION=${BAZALT_ZENOH_VERSION}

ARG BAZALT_PROTOBUF_VERSION
ENV BAZALT_PROTOBUF_VERSION=${BAZALT_PROTOBUF_VERSION}

ARG BAZALT_INSTALL_PREFIX="/opt/bazalt"
ARG BAZALT_INSTALL_LIBDIR="lib"
COPY --from=bazalt-builder --chmod=755 \
      ${BAZALT_INSTALL_PREFIX}/${BAZALT_INSTALL_LIBDIR}/libzenohc.so* \
      ${BAZALT_INSTALL_PREFIX}/${BAZALT_INSTALL_LIBDIR}/libprotobuf.so* \
    /usr/local/lib/

# Ensure dynamic linker can find new libraries
RUN ldconfig
