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
ifndef QUIET
$(info IMAGE is not set, defaulting to directory name $(IMAGE))
endif
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

BUILD_ARGS_BASE ?= NAMESPACE=$(NAMESPACE) PLATFORM=$(PLATFORM) TAG_PREFIX=$(TAG_PREFIX)
BUILD_ARGS ?= VERSION=$(VERSION)
BUILD_ARGS_STRING ?= \
	$(foreach arg,$(BUILD_ARGS_BASE),--build-arg $(arg)) \
	$(foreach arg,$(BUILD_ARGS),--build-arg $(arg))

TAG ?= $(VERSION)-$(PLATFORM)
FQTAG ?= $(NAMESPACE)/$(IMAGE):$(TAG_PREFIX)$(TAG)

list:
	@echo $(VARIANTS)

list-base:
	@echo ""

list-baseless:
	@echo ""

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
	@echo -e "\e[1;32mBuilding $(FQTAG)\e[0m..."
	@echo -e "\e[1;32mUsing build args: $(BUILD_ARGS)\e[0m..."

	@docker build \
		$(BUILD_ARGS_STRING) \
	  	--platform linux/$(PLATFORM) \
		--tag $(FQTAG) \
		.

# push a specific variant
$(VARIANTS:%=push-%):
	@echo -e "\e[1;32mPushing $(FQTAG)\e[0m..."
	@docker push $(FQTAG)
