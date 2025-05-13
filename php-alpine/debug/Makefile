IMAGE := php-alpine

VERSIONS := 84_xdebug_3.21 84_xdebug_edge \
			84_pcov_3.21 84_pcov_edge \
			84_phpdbg_3.21 84_phpdbg_edge

PHP_VERSION = $(word 1,$(subst _, ,$(VERSION)))
DEBUG_PACKAGE = $(word 2,$(subst _, ,$(VERSION)))
OS_VERSION = $(word 3,$(subst _, ,$(VERSION)))

# if debug_package is not phpdbg, prepend "pecl-"
DEBUG_APK_PREFIX = $(if $(filter phpdbg,$(DEBUG_PACKAGE)),,pecl-)

BUILD_ARGS = \
	PHP_VERSION=$(PHP_VERSION) \
	OS_VERSION=$(OS_VERSION) \
	DEBUG_PACKAGE=${DEBUG_APK_PREFIX}$(DEBUG_PACKAGE)

TAG = $(PHP_VERSION)${DEBUG_PACKAGE}-$(OS_VERSION)-$(PLATFORM)

# The include should happen after all variables are defined because the
# included Makefile may rely on these variables.
include ../../.makefiles/docker.Makefile
