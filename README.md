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

Available tags:
- `latest` - Latest build from main branch
- `sha-<commit>` - Specific commit builds

### Local Build

```bash
# Build container image
./astralforge build

# Build disk images
./astralforge build-qcow2  # QCOW2 format
./astralforge build-raw    # RAW format
./astralforge build-iso    # ISO format
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
