ROOT_DIR := $(shell dirname $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

ifneq ($(wildcard $(ROOT_DIR)/.env),)
include $(ROOT_DIR)/.env
else
$(info no .env file found in $(ROOT_DIR))
endif

ifndef NAMESPACE
$(error NAMESPACE is not set. Please set it in the .env file or pass it as an argument.)
endif

ifndef PLATFORMS
PLATFORMS := amd64 arm64
endif

# Define supported actions and build lists of action + versions, archs, etc.
ACTIONS = build

ACTION = $(firstword $(subst -, ,$@))
LAST_WORD = $(lastword $(subst -, ,$@))

MIDDLE_WORD = $(patsubst $(ACTION)-%,%,$(patsubst %-$(LAST_WORD),%,$@))

MAKE_FILES := $(wildcard */Makefile)

DIRS := $(MAKE_FILES:%/Makefile=%)

BASE_DIRS = $(filter base%,$(DIRS))
BASELESS_DIRS = $(filter-out base%,$(DIRS))

MAKE_CMD := $(MAKE) --no-print-directory

list:
	@echo $(DIRS)

list-base:
	@echo $(BASE_DIRS)

list-baseless:
	@echo $(BASELESS_DIRS)

# {action} (e.g. build)
$(ACTIONS):
	@[ -z "$(BASE_DIRS)" ] || $(MAKE) --no-print-directory $(BASE_DIRS:%=$(ACTION)-%)
	@[ -z "$(BASELESS_DIRS)" ] || $(MAKE) --no-print-directory $(BASELESS_DIRS:%=$(ACTION)-%)

# {action}-{dir} (e.g. build-base)
$(foreach ACTION,$(ACTIONS),$(DIRS:%=$(ACTION)-%)):
	@$(MAKE_CMD) -C $(LAST_WORD) $(ACTION)

# {action}-{platform} (e.g. build-amd64)
$(foreach ACTION,$(ACTIONS),$(PLATFORMS:%=$(ACTION)-%)):
	@[ -z "$(BASE_DIRS)" ] || $(MAKE_CMD) $(BASE_DIRS:%=$(ACTION)-%-$(LAST_WORD))
	@[ -z "$(BASELESS_DIRS)" ] || $(MAKE_CMD) $(BASELESS_DIRS:%=$(ACTION)-%-$(LAST_WORD))

# {action}-{dir}-{platform} (e.g. build-base-amd64)
$(foreach ACTION,$(ACTIONS),$(foreach DIR,$(DIRS),$(PLATFORMS:%=$(ACTION)-$(DIR)-%))):
	@$(MAKE_CMD) -C $(MIDDLE_WORD) $(ACTION)-$(LAST_WORD)
