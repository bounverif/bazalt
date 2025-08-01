ARG BAZALT_VERSION=latest
ARG BAZALT_BASE_IMAGE=quay.io/pypa/manylinux_2_28

ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY}
ARG BAZALT_IMAGE_NAME=bazalt
ARG BAZALT_IMAGE_NAME_FULL=${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}
ARG BAZALT_IMAGE_VERSION=${BAZALT_VERSION}
ARG BAZALT_BUILDER_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-builder
ARG BAZALT_DEVEL_IMAGE=${BAZALT_IMAGE_NAME_FULL}:${BAZALT_IMAGE_VERSION}-devel

ARG BAZALT_BUILD_BOOST_VERSION=1.88.0
ARG BAZALT_BUILD_ZENOH_VERSION=1.5.0
ARG BAZALT_BUILD_PROTOBUF_VERSION=5.29.5

FROM ${BAZALT_BASE_IMAGE} AS bazalt-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG BAZALT_BUILD_BOOST_VERSION
ENV BAZALT_BUILD_BOOST_VERSION=${BAZALT_BUILD_BOOST_VERSION}

ARG BAZALT_BUILD_PROTOBUF_VERSION
ENV BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION}

ARG BAZALT_BUILD_ZENOH_VERSION
ENV BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION}

RUN --mount=type=bind,source=./scripts/boost-source-cmake-install.sh,target=/container-build/scripts/boost-source-cmake-install.sh \
    . /container-build/scripts/boost-source-cmake-install.sh

RUN --mount=type=bind,source=./scripts/protobuf-source-install.sh,target=/container-build/scripts/protobuf-source-install.sh \
      BAZALT_PROTOBUF_BUILD_PROTOC_BINARIES="ON" \
      BAZALT_PROTOBUF_BUILD_LIBPROTOC="ON" \
      BAZALT_PROTOBUF_BUILD_SHARED_LIBS="ON" \
    . /container-build/scripts/protobuf-source-install.sh

ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"
RUN --mount=type=bind,source=./scripts,target=/container-build/scripts \
    . /container-build/scripts/rustup-install.sh && \
    rustup-init -y --default-toolchain none --profile minimal

RUN --mount=type=bind,source=./scripts,target=/container-build/scripts \
    . /container-build/scripts/zenoh-c-source-install.sh && \
    . /container-build/scripts/zenoh-cpp-source-install.sh

FROM bazalt-builder AS bazalt-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
