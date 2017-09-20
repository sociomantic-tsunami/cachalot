# Copyright sociomantic labs GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
FROM ubuntu

ARG VERSION_IMAGE

ENV DEBIAN_FRONTEND=noninteractive \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    # fpm is a tool to easily build Debian packages
    # https://fpm.readthedocs.io/en/latest/
    VERSION_FPM=1.9.x \
    # travis is a command-line inteface to the travis CI service
    # https://github.com/travis-ci/travis.rb#the-travis-client-
    VERSION_TRAVIS=1.8.x \
    # jfrog is a command-line interface to JFrog's Bintray apt repo service
    # https://www.jfrog.com/confluence/display/CLI/JFrog+CLI
    # jfrog doesn't support 1.8.x format yet, a full version must be specified
    VERSION_JFROG=1.10.3

LABEL \
    maintainer="Sociomantic Labs GmbH <tsunami@sociomantic.com>" \
    description="Base image for Sociomantic Labs projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE \
    com.sociomantic.version.fpm=$VERSION_FPM \
    com.sociomantic.version.jfrog=$VERSION_JFROG \
    com.sociomantic.version.travis=$VERSION_TRAVIS

COPY docker/ /docker-tmp
RUN cd /docker-tmp && ./base && rm -fr /docker-tmp
