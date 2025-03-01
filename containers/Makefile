BAZALT_IMAGE_REGISTRY ?= localhost
BAZALT_IMAGE_NAME ?= bazalt
BAZALT_TARGET_VERSION ?= latest
BAZALT_CURRENT_VERSION ?= $(shell date +'%Y%m%d')

BAZALT_BUILD_PROTOBUF_VERSION ?= 3.21.12

CONTAINER_BUILD_CONTEXT ?= .

info:
	@echo "bazalt version: ${BAZALT_TARGET_VERSION}"
	@echo "bazalt current version: ${BAZALT_CURRENT_VERSION}"

builder:
	buildah build \
		-f bazalt-devel/Dockerfile \
		--build-arg BAZALT_IMAGE_REGISTRY=${BAZALT_IMAGE_REGISTRY} \
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
