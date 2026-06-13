IMAGE := nodejs-alpine

VERSIONS := 3.23 3.24 edge


TAG = npm-$(VERSION)-$(PLATFORM)

# The include should happen after all variables are defined because the
# included Makefile may rely on these variables.
include ../../../.makefiles/docker.Makefile
