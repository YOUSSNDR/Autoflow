# Use the official ROS 2 Humble desktop image
FROM osrf/ros:humble-desktop

# Install additional tools (gazebo, rviz...)
RUN apt update && apt install -y wget lsb-release gnupg\
    ros-humble-rviz2 \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=amd64] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" | tee /etc/apt/sources.list.d/gazebo-stable.list
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt update && apt install -y ignition-fortress


# Install ROS 2 Gazebo bridges
RUN apt install -y ros-humble-ros-ign-bridge ros-humble-ros-ign-gazebo

RUN useradd -m -u 1000 youss
USER youss
WORKDIR /workspace

# Set up entrypoint to source ROS 2
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "export IGN_GAZEBO_RESOURCE_PATH=/usr/share/ignition/fortress" >> ~/.bashrc
RUN echo "export ROS_DOMAIN_ID=0" >> ~/.bashrc
# Need to source the workspace setup.bash
SHELL ["/bin/bash", "-c"]