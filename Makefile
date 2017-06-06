
# CONFIGURATION
# =============

# Default distributions to build
dists ?= trusty xenial

# The latest tag will not be set at all (even if the dist matches) if this is
# not set to "true". This is to have only one branch to be tagged as latest at
# any given time.
is_latest ?= true

# Built images will be pushed to the registry only if this is set to "true"
push ?= false

# Default DockerHub organization to use to tag (/push) images
dockerhub_org ?= sociomantictsunami

# Default images to build (scanned from available Dockerfiles)
images ?= $(basename $(wildcard *.Dockerfile))

# Default distro to tag as the latest
latest_dist ?= $(lastword $(dists))

################

ifeq "$(is_latest)" "true"
build_args += -l $(latest_dist)
endif

ifeq "$(push)" "true"
build_args += -p
endif

targets := $(foreach t,$(dists),$(addsuffix .$t,$(images)))

.PHONY: all $(targets)

all: $(targets)

define create_recipe
$1.$2: $1.Dockerfile
	./build-img $$(build_args) $$< $$(dockerhub_org) $2
endef
$(foreach d,$(dists),$(foreach i,$(images),$(eval $(call create_recipe,$i,$d))))

# TODO: Generate from Dockerfiles
dlang.trusty: base.trusty
dlang.xenial: base.xenial
