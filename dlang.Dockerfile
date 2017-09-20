# Copyright sociomantic labs GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
FROM sociomantictsunami/base

ARG VERSION_IMAGE

ENV \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    VERSION_EBTREE=6.0.socio* \
    VERSION_DMD1=1.081.* \
    VERSION_TANGORT=1.7.* \
    VERSION_DMD=2.070.* \
    VERSION_DMD_TRANSITIONAL=2.070.* \
    VERSION_D1TO2FIX=0.9.*

LABEL \
    maintainer="Sociomantic Labs GmbH <tsunami@sociomantic.com>" \
    description="Base image for Sociomantic Labs projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE \
    com.sociomantic.version.ebtree=$VERSION_EBTREE \
    com.sociomantic.version.dmd1=$VERSION_DMD1 \
    com.sociomantic.version.tangort=$VERSION_TANGORT \
    com.sociomantic.version.dmd=$VERSION_DMD \
    com.sociomantic.version.dmd-transitional=$VERSION_DMD_TRANSITIONAL \
    com.sociomantic.version.d1to2fix=$VERSION_D1TO2FIX

COPY docker/ /docker-tmp
RUN cd /docker-tmp && ./dlang && rm -fr /docker-tmp
