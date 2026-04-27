# ROS2 Jazzy Development Docker Environments

This repository provides three distinct Docker-based environments for ROS2 Jazzy development. It is designed to support workflows on both AMD64 (Standard PC/Server) and ARM64 (Raspberry Pi/Jetson) architectures, while offering solutions for fast cross-compilation.

## 1. Native AMD64 Environment (`Dockerfile.NativeAMD`)

**Purpose:** The standard development environment for a regular x86_64 / amd64 computer.
**Architecture:** AMD64 (x86_64).
**How it works:** It grabs the AMD64 Ubuntu 24.04 image and installs native AMD64 ROS2 packages and build tools.
**When to use:** 
* You are developing on a standard PC/Laptop and intend to run your code on a standard PC/Laptop.

**Build Command:**
```bash
docker build -f ros_docker_files/Dockerfile.NativeAMD -t ros2-jazzy-amd64 .
```

---

## 2. Native ARM64 Environment (`Dockerfile.NativeARM`)

**Purpose:** A pure ARM64 development environment. 
**Architecture:** ARM64 (aarch64).
**How it works:** It forces the use of the ARM64 Ubuntu image (`--platform=linux/arm64`). It installs native ARM64 ROS2 packages and tools.
**When to use:** 
* You are building directly **on** an actual ARM64 board (like a Jetson or Raspberry Pi).
* You are on an AMD64 PC, but you want an *exact* replica of an ARM environment to test how a script or package behaves natively on ARM. 
*(Note: Building and running this on an AMD64 machine requires Docker BuildKit and QEMU emulation, which makes the build and execution process significantly slower).*

**Build Command:**
```bash
# Optional: If building on an AMD64 host, ensure QEMU is installed and BuildKit is enabled
# sudo apt install docker-buildx-plugin qemu-user-static -y
DOCKER_BUILDKIT=1 docker build -f ros_docker_files/Dockerfile.NativeARM -t ros2-jazzy-arm64 .
```

---

## 3. Fast Cross-Compilation Environment (`Dockerfile.crossARM`)

**Purpose:** Blazing fast compilation of ARM64 code using the processing power of an AMD64 PC.
**Architecture:** The *Container* runs natively on AMD64, but the *Compiled Output* is for ARM64.
**How it works:** Instead of slowly emulating an ARM processor like `NativeARM` does, this builds a native AMD64 container. It downloads the required ARM64 ROS2 libraries into an isolated "sysroot" folder. It then installs GCC cross-compilers (`aarch64-linux-gnu-gcc`) that run natively on your fast AMD PC but have the capability to output binaries mathematically structured for ARM architectures.
**When to use:** 
* You are developing on a powerful AMD64 PC and need to compile a large ROS2 codebase for a target ARM robot, and the emulated `NativeARM` build is taking too long.

**Build Command:**
```bash
docker build -f ros_docker_files/Dockerfile.crossARM -t ros2-jazzy-cross-arm .
```

### ⚙️ Using the CMake Toolchain for Cross-Compilation

To tell CMake to use the cross-compilers instead of standard host compilers when using the `crossARM` container, a CMake toolchain file is provided at `ros_docker_files/cmake_toolchain/cross-toolchain.cmake`.

**Purpose of the Toolchain:** 
* Points CMake to `/usr/bin/aarch64-linux-gnu-gcc` and `/usr/bin/aarch64-linux-gnu-g++`.
* Tells CMake to look for ROS2 dependencies inside the ARM64 sysroot (`/opt/ros/jazzy-arm64` and `/usr/lib/aarch64-linux-gnu`) instead of the host's AMD64 library paths.

**How to use:**
When inside the `ros2-jazzy-cross-arm` container running on your PC, build your ROS2 workspace with `colcon` by passing the toolchain file:

```bash
# Mount your workspace and run the container
docker run -it --rm -v $(pwd):/workspace ros2-jazzy-cross-arm

# Inside the crossARM container:
colcon build --cmake-args -DCMAKE_TOOLCHAIN_FILE=/workspace/cmake_toolchain/cross-toolchain.cmake
```

---

## Included Dependencies (All Images)

For consistency, all three environments include the same essential toolkit:
- **Build Tools:** `build-essential`, `cmake`, `git`, `python3-pip`, `libpython3-dev`
- **ROS2 Core:** `ros-jazzy-ros-base`, `ros-jazzy-rosidl-default-generators`
- **Common ROS2 Msgs:** `sensor-msgs`, `std-msgs`, `geometry-msgs`, `diagnostic-msgs`, `rtcm-msgs`
- **System Libraries:** `libserial-dev`, `libcurl4-openssl-dev`, `libusb-1.0-0-dev`
- **Python Extensions:** `colcon-common-extensions`, `colcon-ros-cargo`, `python3-rosdep`, `empy`
