ARG ZENOH_PICO_VERSION=latest

FROM debian:12 AS zenoh-pico-downloader
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

ARG ZENOH_PICO_VERSION

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        export ZENOH_ARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        export ZENOH_ARCH="arm64"; \
    fi && \
    wget -q https://github.com/eclipse-zenoh/zenoh-pico/releases/download/${ZENOH_PICO_VERSION}/zenoh-pico-${ZENOH_PICO_VERSION}-linux-${ZENOH_ARCH}-standalone.zip -O /tmp/zenoh-pico.zip && \
    unzip /tmp/zenoh-pico.zip -d /tmp/zenoh-pico && \
    mv /tmp/zenoh-pico/include /usr/local && \
    mv /tmp/zenoh-pico/lib /usr/local && \
    rm /tmp/zenoh-pico.zip && \
    rm -rf /tmp/zenoh-pico

FROM debian:12 AS zenoh-pico-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

FROM debian:12 AS zenoh-pico-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

COPY --from=zenoh-pico-downloader /usr/local/ /usr/local/