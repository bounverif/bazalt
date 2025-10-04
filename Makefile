PROJECT_SOURCE_DIR := $(PWD)
PROJECT_BUILD_DIR := /tmp/build

all: configure build

set-project-dir:
	$(eval PROJECT_SOURCE_DIR := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

configure: set-project-dir
	cmake \
		-S $(PROJECT_SOURCE_DIR) \
		-B $(PROJECT_BUILD_DIR) \
		-DBAZALT_BUILD_TESTS=OFF

build: configure
	cmake --build $(PROJECT_BUILD_DIR)

purge:
	rm -rf $(PROJECT_BUILD_DIR)
	$(MAKE) configure

test: build
	ctest --test-dir $(PROJECT_BUILD_DIR) --output-on-failure

install: build
	cmake --install $(PROJECT_BUILD_DIR)

local_install: build
	cmake --install $(PROJECT_BUILD_DIR) --prefix ~/.local

.PHONY: all configure build test install local_install purge
