VERSIONS := 1.44.5_3.21

TRIAGE_VERSION = $(word 1,$(subst _, ,$(VERSION)))
OS_VERSION = $(word 2,$(subst _, ,$(VERSION)))

BUILD_ARGS = TRIAGE_VERSION=$(TRIAGE_VERSION) OS_VERSION=$(OS_VERSION)

TAG = $(TRIAGE_VERSION)-$(OS_VERSION)-$(PLATFORM)

# The include should happen after all variables are defined because the
# included Makefile may rely on these variables.
include ../.makefiles/docker.Makefile
