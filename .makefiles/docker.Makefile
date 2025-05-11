ROOT_DIR := $(shell dirname $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
IMG_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ifneq ($(wildcard $(ROOT_DIR)/.env),)
include $(ROOT_DIR)/.env
else
$(info no .env file found in $(ROOT_DIR))
endif

ifndef NAMESPACE
$(error NAMESPACE is not set. Please set it in the .env file or pass it as an argument.)
endif

ifndef VERSIONS
$(error ARGS is not set. Please set it in the image's Makefile.)
endif

ifndef IMAGE
IMAGE := $(shell basename $(IMG_DIR))
$(info IMAGE is not set, defaulting to directory name $(IMAGE))
endif

ifndef PLATFORMS
PLATFORMS := amd64 arm64
endif

DOCKER_BUILDKIT ?= 1
export DOCKER_BUILDKIT

VARIANTS := $(foreach v,$(VERSIONS),$(foreach p,$(PLATFORMS),$(v)-$(p)))

ACTION = $(word 1,$(subst -, ,$@))
WORD_2 = $(word 2,$(subst -, ,$@))
VERSION = $(WORD_2)
PLATFORM = $(word 3,$(subst -, ,$@))

BUILD_ARGS ?= NAMESPACE=$(NAMESPACE) VERSION=$(VERSION) PLATFORM=$(PLATFORM)
BUILD_ARGS_STRING ?= $(foreach arg,$(BUILD_ARGS),--build-arg $(arg))

TAG ?= $(VERSION)-$(PLATFORM)

list:
	@echo $(VARIANTS)

# build all variants
build: $(VARIANTS:%=build-%)

# build all variants for a specific platform
$(PLATFORMS:%=build-%):
	@$(MAKE) $(VERSIONS:%=build-%-$(WORD_2))

# build all variants for a specific version
$(VERSIONS:%=build-%):
	@$(MAKE) $(PLATFORMS:%=build-$(WORD_2)-%)

# build a specific variant
$(VARIANTS:%=build-%):
	@echo -e "\e[1;32mBuilding $(NAMESPACE)/$(IMAGE):$(TAG)\e[0m..."
	@echo -e "\e[1;32mUsing build args: $(BUILD_ARGS)\e[0m..."

	@docker build \
		$(BUILD_ARGS_STRING) \
	  	--platform linux/$(PLATFORM) \
		--tag $(NAMESPACE)/$(IMAGE):$(TAG) \
		.
