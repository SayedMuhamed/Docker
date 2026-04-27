# ROS2 Jazzy Development Docker Environments

This directory contains Dockerfiles for setting up native ROS2 Jazzy development environments on both AMD64 (PC/Server) and ARM64 (Raspberry Pi/Jetson/Cloud) architectures.

## Contents

### 1. Dockerfile.NativeAMD
A native build environment for **x86_64 / amd64** architectures. 
- **Base OS**: Ubuntu 24.04 (Noble)
- **ROS2 Version**: Jazzy Jalisco

### 2. Dockerfile.NativeARM
A native build environment for **aarch64 / arm64** architectures.
- **Base OS**: Ubuntu 24.04 (Noble)
- **Architecture**: Enforced via `--platform=linux/arm64`

---

## Included Dependencies

Both images come pre-installed with:
- **Build Tools**: `build-essential`, `cmake`, `git`, `python3-pip`, `libpython3-dev`
- **ROS2 Core Packages**: `ros-jazzy-ros-base`, `ros-jazzy-rosidl-default-generators`
- **ROS2 Communication & Data**: `sensor-msgs`, `std-msgs`, `geometry-msgs`, `diagnostic-msgs`, `rtcm-msgs`
- **Common Libraries**: `libserial-dev`, `libcurl4-openssl-dev`, `libusb-1.0-0-dev`
- **Python Tools**: `colcon-common-extensions`, `colcon-ros-cargo`, `python3-rosdep`, `empy`

---

## Prerequisites

### Native AMD64 (Standard PC)
- Docker installed and running.

### Native ARM64 (Cross-building on PC)
To build the ARM image on an AMD64 host, you must have **BuildKit** and **QEMU** emulators:
```bash
# Install required plugins (Ubuntu/WSL)
sudo apt update && sudo apt install docker-buildx-plugin qemu-user-static -y
```

---

## Build Instructions

Run these commands from the **parent directory** of `ros_docker_files`:

### Build for AMD64
```bash
docker build -f ros_docker_files/Dockerfile.NativeAMD -t ros2-jazzy-amd64 .
```

### Build for ARM64
*Note: Use `DOCKER_BUILDKIT=1` to ensure the platform flag is respected.*
```bash
DOCKER_BUILDKIT=1 docker build -f ros_docker_files/Dockerfile.NativeARM -t ros2-jazzy-arm64 .
```

---

## Usage

### Starting the Container
To start an interactive session and mount your current source code:
```bash
docker run -it --rm \
    -v $(pwd):/workspace \
    ros2-jazzy-amd64 # or ros2-jazzy-arm64
```

### Features included in the environment:
- **Workspace**: Automatically starts in `/workspace`.
- **Environment**: ROS2 is automatically sourced via `~/.bashrc`.
- **Rosdep**: Initialized and updated during build.

---

## Notes on Caching
If you switch between building AMD and ARM versions and notice "Using Cache" on the wrong architecture, force a clean build using the `--no-cache` flag:
```bash
docker build --no-cache -f ros_docker_files/Dockerfile.NativeARM -t ros2-jazzy-arm64 .
```
