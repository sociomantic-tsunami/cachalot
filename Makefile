
# CONFIGURATION
# =============

# Default distributions to build
DIST ?= trusty xenial

# Default DockerHub organization to use to tag (/push) images
DOCKER_ORG ?= sociomantictsunami

# Default images to build (scanned from available Dockerfiles)
IMAGES ?= $(basename $(wildcard *.Dockerfile))

# Default distro to tag as the latest
LATEST_DIST ?= $(lastword $(DIST))

# Default git reference we are building
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD || echo UNKNOWN)

# If specified, a new image with this specific tag will be created
TAG ?= 


################


.PHONY: all
all: build

build_targets := $(foreach t,$(DIST),$(addsuffix .$t,$(IMAGES)))
.PHONY: $(build_targets) build
build: $(build_targets)

push_targets := $(foreach t,$(DIST),$(patsubst %,push-%.$t,$(IMAGES)))
.PHONY: $(push_targets) push
push: $(push_targets)


docker_tag := $(shell echo "$(BRANCH)" | cut -d. -f1)$(if $(findstring -,$(TAG)),-test)

define create_recipe
$1.$2: $1.$2.stamp

$1.$2.stamp: $1.Dockerfile
	./build-img $(if $(TAG),-V "$(TAG)") "$(DOCKER_ORG)/$1:$2-$(docker_tag)"
ifdef TAG
	@printf "\n"
	docker tag "$(DOCKER_ORG)/$1:$2-$(docker_tag)" "$(DOCKER_ORG)/$1:$2-$(TAG)"
endif
# Tag the latest only if is not a pre-release tag
ifeq ($(LATEST_DIST),$2$(findstring -,$(TAG)))
	@printf "\n"
	docker tag "$(DOCKER_ORG)/$1:$2-$(docker_tag)" "$(DOCKER_ORG)/$1"
endif
	@printf "==================================================\n\n"
	@touch $$@

push-$1.$2: $1.$2.stamp
	docker push "$(DOCKER_ORG)/$1:$2-$(docker_tag)"
ifdef TAG
	docker push "$(DOCKER_ORG)/$1:$2-$(TAG)"
endif
# Push the latest only if is not a pre-release tag
ifeq ($(LATEST_DIST),$2$(findstring -,$(TAG)))
	docker push "$(DOCKER_ORG)/$1"
endif
endef

$(foreach d,$(DIST),$(foreach i,$(IMAGES),$(eval $(call create_recipe,$i,$d))))

# Dependencies
# TODO: Generate from Dockerfiles
dlang.trusty.stamp: base.trusty.stamp
dlang.xenial.stamp: base.xenial.stamp

.PHONY: clean
clean:
	$(RM) $(addsuffix .stamp,$(build_targets))
