set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 1. Compilers
set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# 2. Target Sysroot
set(CMAKE_SYSROOT /)
set(CMAKE_STAGING_PREFIX /workspace/install)

# 3. Search Paths for Libraries
# Look in our custom ARM64 ROS folder first
set(CMAKE_FIND_ROOT_PATH 
    /opt/ros/jazzy-arm64
    /usr/lib/aarch64-linux-gnu
    /lib/aarch64-linux-gnu
    /usr/include/aarch64-linux-gnu
)

# 4. Search Behavior
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 5. Python Handling - use NATIVE Python for build scripts
set(PYTHON_EXECUTABLE /usr/bin/python3)
set(Python3_EXECUTABLE /usr/bin/python3 CACHE FILEPATH "Python3 executable" FORCE)
set(Python3_FIND_STRATEGY LOCATION)

# Point to ARM Python headers for compilation
set(Python3_INCLUDE_DIRS /usr/include/python3.12 CACHE STRING "Python3 include dirs" FORCE)
set(Python3_LIBRARIES /usr/lib/x86_64-linux-gnu/libpython3.12.so CACHE FILEPATH "Python3 library" FORCE)

# 6. Ensure ROS2 finds ARM64 packages
set(ENV{AMENT_PREFIX_PATH} "/opt/ros/jazzy-arm64")
set(ENV{CMAKE_PREFIX_PATH} "/opt/ros/jazzy-arm64")
