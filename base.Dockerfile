FROM ubuntu

ARG VERSION_IMAGE

ENV DEBIAN_FRONTEND=noninteractive \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    VERSION_FPM=1.8.1 \
    VERSION_JFROG=1.8.0 \
    VERSION_TRAVIS=1.8.8

LABEL \
    maintainer="Sociomantic Labs GmbH <tsunami@sociomantic.com>" \
    description="Base image for Sociomantic Labs projects" \
    # Labels for programs and image versions
    com.sociomantic.version.image=$VERSION_IMAGE \
    com.sociomantic.version.fpm=$VERSION_FPM \
    com.sociomantic.version.jfrog=$VERSION_JFROG \
    com.sociomantic.version.travis=$VERSION_TRAVIS

COPY docker/ /docker-tmp
RUN /docker-tmp/run-scripts base \
		base \
		git \
		fpm \
		jfrog \
		travis \
	&& rm -fr /docker-tmp
