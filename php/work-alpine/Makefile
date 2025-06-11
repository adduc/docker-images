IMAGE := php-alpine

VERSIONS := 84_3.21 84_3.22 84_edge

PHP_VERSION = $(word 1,$(subst _, ,$(VERSION)))
OS_VERSION = $(word 2,$(subst _, ,$(VERSION)))

BUILD_ARGS = PHP_VERSION=$(PHP_VERSION) OS_VERSION=$(OS_VERSION)

TAG = $(PHP_VERSION)-work-$(OS_VERSION)-$(PLATFORM)

# The include should happen after all variables are defined because the
# included Makefile may rely on these variables.
include ../../.makefiles/docker.Makefile
