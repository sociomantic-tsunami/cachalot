# Copyright dunnhumby Germany GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
FROM sociomantictsunami/develbase

ARG VERSION_IMAGE

ENV \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    VERSION_EBTREE=1:6.0.socio* \
    VERSION_DMD=2.080.* \
    VERSION_DMD_TRANSITIONAL=2.078.* \
    VERSION_HMOD=0.3.*

LABEL \
    maintainer="dunnhumby Germany GmbH <tsunami@sociomantic.com>" \
    description="Base D development image for Sociomantic Labs projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE \
    com.sociomantic.version.ebtree=$VERSION_EBTREE \
    com.sociomantic.version.dmd=$VERSION_DMD \
    com.sociomantic.version.dmd-transitional=$VERSION_DMD_TRANSITIONAL \
    com.sociomantic.version.hmod=$VERSION_HMOD

COPY docker/ /docker-tmp
RUN cd /docker-tmp && ./develdlang && rm -fr /docker-tmp
