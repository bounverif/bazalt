BAZALT_IMAGE_REGISTRY ?= localhost
BAZALT_IMAGE_REGISTRY_REMOTE ?= ghcr.io/bounverif
BAZALT_IMAGE_NAME ?= bazalt
BAZALT_TARGET_VERSION ?= latest
BAZALT_CURRENT_VERSION ?= $(shell date +'%Y%m%d')

BAZALT_BUILD_BOOST_VERSION ?= latest
BAZALT_BUILD_PROTOBUF_VERSION ?= 3.21.12
BAZALT_BUILD_ZENOH_VERSION ?= 1.5.0

CONTAINER_BUILD_CONTEXT ?= .

info:
	@echo "bazalt version: ${BAZALT_TARGET_VERSION}"
	@echo "bazalt current version: ${BAZALT_CURRENT_VERSION}"

builder:
	buildah build \
		-f bazalt-devel/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_VERSION=${BAZALT_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-builder \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_TARGET_VERSION}-builder \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_CURRENT_VERSION}-builder \
	${CONTAINER_BUILD_CONTEXT}

devel: builder
	buildah build \
		-f bazalt-devel/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_VERSION=${BAZALT_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_TARGET_VERSION}-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_CURRENT_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

runtime:
	buildah build \
		-f bazalt-devel/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_VERSION=${BAZALT_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-runtime \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_TARGET_VERSION} \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_CURRENT_VERSION} \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_TARGET_VERSION}-runtime \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_CURRENT_VERSION}-runtime \
	${CONTAINER_BUILD_CONTEXT}

router:
	buildah build \
		-f bazalt-devel/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_VERSION=${BAZALT_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-router \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_TARGET_VERSION}-router \
		--tag ${BAZALT_IMAGE_REGISTRY}/${BAZALT_IMAGE_NAME}:${BAZALT_CURRENT_VERSION}-router \
	${CONTAINER_BUILD_CONTEXT}

boost:
	buildah build \
		-f bazalt-boost/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_BUILD_BOOST_VERSION=${BAZALT_BUILD_BOOST_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-boost-builder \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-boost:${BAZALT_BUILD_BOOST_VERSION}-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-boost:${BAZALT_BUILD_BOOST_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

protobuf:
	buildah build \
		-f bazalt-protobuf/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_BUILD_PROTOBUF_VERSION=${BAZALT_BUILD_PROTOBUF_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-protobuf-builder \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-protobuf:${BAZALT_BUILD_PROTOBUF_VERSION}-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-protobuf:${BAZALT_BUILD_PROTOBUF_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

zenoh:
	buildah build \
		-f bazalt-zenoh/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-zenoh-builder \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

zenoh-release:
	buildah build \
		-f bazalt-zenoh/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-zenoh-release \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-release \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-release \
	${CONTAINER_BUILD_CONTEXT}

zenoh-release-devel:
	buildah build \
		-f bazalt-zenoh/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
		--build-arg BAZALT_IMAGE_REGISTRY_REMOTE=${BAZALT_IMAGE_REGISTRY_REMOTE} \
		--build-arg BAZALT_IMAGE_NAME=${BAZALT_IMAGE_NAME} \
		--build-arg BAZALT_BUILD_ZENOH_VERSION=${BAZALT_BUILD_ZENOH_VERSION} \
		--format oci \
		--layers=true \
		--target bazalt-zenoh-release-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-release-devel \
		--tag ${BAZALT_IMAGE_REGISTRY}/bazalt-zenoh:${BAZALT_BUILD_ZENOH_VERSION}-release-devel \
	${CONTAINER_BUILD_CONTEXT}
