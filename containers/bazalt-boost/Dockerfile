ARG BAZALT_VERSION=latest
ARG BAZALT_DEBIAN_VERSION=12
ARG BAZALT_IMAGE_REGISTRY=localhost
ARG BAZALT_IMAGE_NAME=bazalt

ARG BAZALT_BUILD_BOOST_VERSION=latest
ARG BAZALT_IMAGE_VERSION=${BAZALT_BUILD_BOOST_VERSION}-boost

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-boost-builder
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
RUN if [ "${BAZALT_BUILD_BOOST_VERSION}" = "latest" ]; then \
      BAZALT_BUILD_BOOST_VERSION_RAW="$(curl -s https://api.github.com/repos/boostorg/boost/releases/latest | jq -r .tag_name)"; \
      BAZALT_BUILD_BOOST_VERSION="$(echo "${BAZALT_BUILD_BOOST_VERSION_RAW}" | sed -E 's/^boost-//')"; \
    fi && \
    git clone -j$(nproc) --recursive --depth 1 --branch boost-${BAZALT_BUILD_BOOST_VERSION} "https://github.com/boostorg/boost.git" /tmp/boost && \
    cd /tmp/boost && \
    git checkout boost-${BAZALT_BUILD_BOOST_VERSION}; \
    mkdir -p /etc/bazalt && \
    printf "%s\\n" "$(git tag --points-at HEAD)" >> /etc/bazalt/BOOST_VERSION && \
    ./bootstrap.sh --prefix=/usr/local --without-libraries=python &&\
    ./b2 link=static cxxflags=-fPIC cflags=-fPIC -j$(nproc) install &&\
    cd / && rm -rf /tmp/boost

FROM docker.io/library/debian:${BAZALT_DEBIAN_VERSION} AS bazalt-boost
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

COPY --from=bazalt-boost-builder /usr/local/lib /usr/local/lib/
