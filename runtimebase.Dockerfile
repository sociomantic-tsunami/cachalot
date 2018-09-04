# Copyright dunnhumby Germany GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
FROM ubuntu

ARG VERSION_IMAGE

# DUMB-INIT
# SOURCE https://github.com/Yelp/dumb-init
ARG VERSION_DUMB_INIT="1.2.2"
ARG DUMB_INIT_SHA256="37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9"

ENV DEBIAN_FRONTEND=noninteractive \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    VERSION_DUMB_INIT=$VERSION_DUMB_INIT \
    DUMB_INIT_SHA256=$DUMB_INIT_SHA256

LABEL \
    maintainer="dunnhumby Germany GmbH <tsunami@sociomantic.com>" \
    description="Base runtime image for Sociomantic projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE

COPY docker/ /docker-tmp
RUN cd /docker-tmp && ./runtimebase && rm -fr /docker-tmp

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
