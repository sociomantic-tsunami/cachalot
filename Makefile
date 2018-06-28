# Copyright dunnhumby Germany GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

# CONFIGURATION
# =============

# Default distributions to build
DIST ?= xenial

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
$1.$2: .$1.$2.stamp

# Automatic image dependency
# We just look for the FROM line and see if the image is build from an image
# from our same $(DOCKER_ORG). If so we assume we know how to build it and add
# it as a dependency.
__dep_$1.$2 := $$(shell sed -rn 's|^\s*FROM\s+$(DOCKER_ORG)/(.*)(:.*)?.*$$$$|\1|p' $1.Dockerfile)
ifneq ($$(__dep_$1.$2),)
.$1.$2.stamp: .$$(__dep_$1.$2).$2.stamp
endif

.$1.$2.stamp: $1.Dockerfile $(wildcard docker/*)
	./build-img $(if $(TAG),-V "$(TAG)") "$(DOCKER_ORG)/$1:$2-$(docker_tag)" $(BUILD_ARGS) $($1.$2.BUILD_ARGS)
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

push-$1.$2: .$1.$2.stamp
	docker push "$(DOCKER_ORG)/$1:$2-$(docker_tag)"
ifdef TAG
	docker push "$(DOCKER_ORG)/$1:$2-$(TAG)"
endif
# Push the latest only if is not a pre-release tag
ifeq ($(LATEST_DIST),$2$(findstring -,$(TAG)))
	docker push "$(DOCKER_ORG)/$1:latest"
endif

.PHONY: test-$1.$2
test-$1.$2: .$1.$2.stamp
	test/test "$(DOCKER_ORG)/$1:$2-$(docker_tag)"
endef

$(foreach d,$(DIST),$(foreach i,$(IMAGES),$(eval $(call create_recipe,$i,$d))))

.PHONY: pre-test
pre-test:
	./docker/last-version run-tests

.PHONY: test
test: $(foreach d,$(DIST),$(foreach i,$(IMAGES),test-$i.$d))

.PHONY: clean
clean:
	$(RM) $(patsubst %,.%.stamp,$(build_targets))
