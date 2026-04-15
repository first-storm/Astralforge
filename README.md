# Astralforge

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A minimal Fedora Silverblue custom image template. Only **600+** lines bash and a `Containerfile`. 

## Quick Start

### Recommended: Use GitHub Actions (Automated)

1. Fork this repository
2. GitHub Actions will automatically build and push images to `ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME`
3. Images are built on:
   - Every push to `main` branch
   - Every pull request
   - Daily at 10:05 UTC
   - Manual workflow dispatch
4. Disk artifact builds, including ISO builds, use `ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest`. Run the container image workflow first, and make sure the GHCR image exists before starting a disk artifact workflow.

Available tags:
- `latest` - Latest build from main branch
- `sha-<commit>` - Specific commit builds

### Local Build

```bash
# Build container image
./astralforge build

# Build disk images. Run ./astralforge build first so the target image exists locally.
./astralforge build-qcow2  # QCOW2 format
./astralforge build-raw    # RAW format
./astralforge build-iso    # ISO format
```

To make an installed system track a GHCR image instead of a local image, build the ISO with `ASTRALFORGE_IMAGE` set to the GHCR reference:

```bash
ASTRALFORGE_IMAGE=ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest ./astralforge build-iso
```

## Customize

Edit [build_files/build.sh](build_files/build.sh) to customize your image:

```bash
# Install packages
dnf5 install -y vim

# Enable services
systemctl enable podman.socket
```

## Configuration

Copy `astralforge.env.example` to `.astralforge.env` and modify as needed.

## Base Image

Defaults to `quay.io/fedora/fedora-silverblue:44`. Change in [Containerfile](Containerfile).
