# Indicates docker image
FROM osrf/ros:humble-desktop-full

LABEL org.opencontainers.image.source=https://github.com/isri-aist/mc_rtc_tutorials
LABEL org.opencontainers.image.description="mc_rtc_tutorial image"
LABEL org.opencontainers.image.licenses=BSD

# Configure environment
ENV DISPLAY host.docker.internal:0.0

# Set default bash shell
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y curl ca-certificates gpg wget software-properties-common

# Install mc_rtc and ROS plugins
RUN curl -1sLf 'https://dl.cloudsmith.io/public/mc-rtc/head/setup.deb.sh' | bash
RUN apt-get install -y \
    libmc-rtc-dev \
    mc-rtc-utils \
    ros-${ROS_DISTRO}-mc-rtc-plugin \
    ros-${ROS_DISTRO}-mc-rtc-tools \
    ros-humble-gazebo-ros-pkgs \ 
    ros-humble-hardware-interface

# Install cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
        | gpg --dearmor - \
        | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' \
        | tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    && apt-get update \
    && apt-get install -y \
        kitware-archive-keyring \
        cmake

# Needed for mc_robotiq2f
RUN apt-get install qhull-bin

# Needed for mc_rtde
RUN add-apt-repository ppa:sdurobotics/ur-rtde \
    && apt-get update \
    && apt-get install librtde librtde-dev \
    && echo "/opt/ros/${ROS_DISTRO}/lib" | sudo tee -a /etc/ld.so.conf.d/ros.conf \
    ldconfig
WORKDIR /opt
RUN git clone https://github.com/jrl-umi3218/ur_modern_driver && \
    cd ur_modern_driver && \
    mkdir build && cd build && \
    cmake .. && \
    make install

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./dockerfiles/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /root
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
