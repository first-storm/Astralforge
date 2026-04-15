# Base Image Argument
## Define the base image to use. This must be declared before any FROM directive
## to be available in all build stages.
ARG BASE_IMAGE=quay.io/fedora/fedora-silverblue:44

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files/ /

# Main Image Stage
FROM ${BASE_IMAGE}

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
#
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

## Build Arguments
## These are used for image metadata and traceability
ARG ASTRALFORGE_GIT_SHA=unknown
ARG ASTRALFORGE_SOURCE=

## OCI Labels
## Standard labels for tracking image provenance
LABEL org.opencontainers.image.revision=${ASTRALFORGE_GIT_SHA}
LABEL org.opencontainers.image.source=${ASTRALFORGE_SOURCE}

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## Make modifications desired in your image and install packages by modifying the build.sh script
## The following RUN directive does all the things required to run "build.sh" as recommended.
##
## Mount types explained:
## - bind mount from ctx: Access build scripts without copying them into the final image
## - cache mount /var/cache: Speed up package manager operations across builds
## - cache mount /var/log: Preserve logs across builds for debugging
## - tmpfs mount /tmp: Fast temporary storage that doesn't persist

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
## This checks for bootc compatibility and structural correctness.
RUN bootc container lint
