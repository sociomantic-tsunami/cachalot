FROM sociomantictsunami/base

ARG VERSION_IMAGE

ENV \
    # Environment variables for program and image versions
    # (scripts use them to know which version to install)
    VERSION_IMAGE=$VERSION_IMAGE \
    VERSION_EBTREE=v6.0.socio6 \
    VERSION_DMD1=v1.080.0 \
    VERSION_TANGORT=v1.6.0 \
    VERSION_DMD=2.070.2-0 \
    VERSION_DMD_TRANSITIONAL=v2.070.2 \
    VERSION_D1TO2FIX=v0.9.0

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
RUN /docker-tmp/run-scripts dlang \
		ebtree \
		dmd1 \
		tangort \
		dmd \
		dmd-transitional \
		d1to2fix \
	&& rm -fr /docker-tmp
