# Use the official ROS 2 Humble base image
FROM osrf/ros:humble-desktop-jammy

# Set the environment variables for non-interactive installations
# ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
WORKDIR /root/ros2_ws
RUN apt-get update && apt-get install -y bash \
    build-essential \
    cmake \
    python3-pip \
    git \
    wget \
    libboost-all-dev \
    libeigen3-dev \
    python3-colcon-common-extensions \
    python3-rosdep \
    ament-cmake \
    ros-humble-rclcpp \
    ros-humble-rosidl-typesupport-c \
    ros-humble-rosidl-typesupport-cpp \
    python3-vcstools \
    && rm -rf /var/lib/apt/lists/*

# Install OMPL and its dependencies
RUN apt-get update && apt-get install -y \
    libompl-dev \
    && rm -rf /var/lib/apt/lists/*

# Ensure /root/ros2_ws/src exists and initialize rosdep conditionally
RUN mkdir -p /root/ros2_ws/src && \
    /bin/bash -c "source /opt/ros/humble/setup.bash && \
    if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
        rosdep init; \
    fi && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build"

# Source ROS 2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Set up a workspace for ROS 2
RUN mkdir -p /root/ros2_ws/src
WORKDIR /root/ros2_ws

# Clone the two tool repositories
RUN git clone https://github.com/HybridSystemsLab/hybridRRT-Ccode.git
RUN git clone https://github.com/HybridSystemsLab/hybridSST-Ccode.git

# Set environmment variable path to /o[t/ros/humble
ENV CMAKE_PREFIX_PATH=/opt/ros/humble
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Set the entrypoint to bash
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && cd hybridRRT-Ccode && mkdir build && cd build && cmake .. && make && ./examples/bouncing_ball"
# CMD ["/bin/sh"]
# CMD ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && cd hybridRRT-Ccode && mkdir -p build && cd build && cmake .. && make && ./examples/bouncing_ball"]
# CMD ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && cd hybridSST-Ccode && mkdir -p build && cd build && cmake .. && make && ./examples/multicopter"]
CMD ["/bin/bash"]
