# Copyright dunnhumby Germany GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
FROM ubuntu

ARG VERSION_IMAGE

ENV DEBIAN_FRONTEND=noninteractive \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE

LABEL \
    maintainer="dunnhumby Germany GmbH <tsunami@sociomantic.com>" \
    description="Base runtime image for Sociomantic projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE

COPY docker/ /docker-tmp
RUN cd /docker-tmp && ./runtimebase && rm -fr /docker-tmp
