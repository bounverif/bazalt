ZENOH_PICO_IMAGE_NAME ?= localhost/zenoh-pico
ZENOH_PICO_TARGET_VERSION ?= latest
ZENOH_PICO_CURRENT_VERSION := $(if $(filter latest,$(ZENOH_PICO_TARGET_VERSION)),$(shell curl -s https://api.github.com/repos/eclipse-zenoh/zenoh-pico/releases/latest | jq -r .tag_name),$(ZENOH_PICO_VERSION))

CONTAINER_BUILD_CONTEXT_ROOT ?= .

ZENOH_PICO_BUILD_PROTOBUF_VERSION ?= 3.15.8

info:
	@echo "zenoh pico version: ${ZENOH_PICO_VERSION}"
	@echo "zenoh pico current version: ${ZENOH_PICO_CURRENT_VERSION}"

devel:
	buildah build \
		-f zenoh-pico-devel/Dockerfile \
		--build-arg ZENOH_PICO_IMAGE_NAME=${ZENOH_PICO_IMAGE_NAME} \
		--build-arg ZENOH_PICO_VERSION=${ZENOH_PICO_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target zenoh-pico-devel \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_TARGET_VERSION}-devel \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_CURRENT_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT_ROOT}/zenoh-pico-devel

runtime:
	buildah build \
		-f zenoh-pico-runtime/Dockerfile \
		--build-arg ZENOH_PICO_IMAGE_NAME=${ZENOH_PICO_IMAGE_NAME} \
		--build-arg ZENOH_PICO_VERSION=${ZENOH_PICO_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target zenoh-pico-downloader \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_TARGET_VERSION} \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_CURRENT_VERSION} \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_TARGET_VERSION}-runtime \
		--tag ${ZENOH_PICO_IMAGE_NAME}:${ZENOH_PICO_CURRENT_VERSION}-runtime \
	${CONTAINER_BUILD_CONTEXT_ROOT}/zenoh-pico-runtime
