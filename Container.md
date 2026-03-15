# Container 

You will find here info on the creation of the container allowing us to use ros2 (humble) in it.

## Install
My Docker install:

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER  # Add your user to the docker group
newgrp docker  # Refresh group permissions
```
Adding your user to the docker group allows you to use the docker commands witheout sudo.

To use the GPU I also add :

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
```
## Container

### Dockerfile

Create a file named Dockerfile and add this inside:

```dockerfile
# Use the official ROS 2 Humble desktop image
FROM osrf/ros:humble-desktop

# Install additional tools (rviz...)
RUN apt update && apt install -y wget lsb-release gnupg\
    ros-humble-rviz2 \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Install the supported version of gazebo (gazebo ign)
RUN echo "deb [arch=amd64] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" | tee /etc/apt/sources.list.d/gazebo-stable.list
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt update && apt install -y ignition-fortress


# Install ROS 2 Gazebo bridges
RUN apt install -y ros-humble-ros-ign-bridge ros-humble-ros-ign-gazebo

# create a new user for the container, make him a home directory and set it user ID here to 1000 
RUN useradd -m -u 1000 youss
USER youss
WORKDIR /workspace

# Set up entrypoint to source ROS 2 (will allow us to use the ros and gazebo commands)
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "export IGN_GAZEBO_RESOURCE_PATH=/usr/share/ignition/fortress" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
```

### Build Image
After making the Dockerfile you need to Build the image in the terminal with this bash command (you need to be placed in the same directory as the Dockerfile):
```bash
docker build -t autoflow .
```
It will create a local image named Autoflow.
(The dot at the end is require)  
You will need to rebuild the image if you modify the Dockerfile

## Run the container
They are two ways to run the container
### Bash commands
with the following commands:
```bash
xhost +local:
```
To allows the container to display GUI windows on the host.

start the container with:
```bash
docker run -it \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOME/Desktop/Autoflow/ros:/ros" \
  --network=host \
  --gpus all \  # Only if using GPU
  #--device=/dev/ttyUSB0 \  # to access USB serial device
  #--device=/dev/video0 \  # to access Webcam
  Autoflow
```

- --env="DISPLAY" and --volume enable GUI apps.
- --network=host simplifies ROS 2 communication between containers/host.
- --gpus all enables GPU access (remove if not needed).
- --volume="/path/on/host:/path/in/container" to oppen the container on a wanted project.

### Vscode devcontainers
I prefer using Vscode with the devcontainer extension allowing me to access my container from vscode.

#### Install "Dev Containers"
In VSCode install the "Dev Container" extension by Microsoft.

#### .devcontainer configuration
In the project folder create a .devcontainer directory:
```bash
mkdir -p .devcontainer
```
In this directory create a "devcontainer.json" file with the following containt:
```Json
{
  "name": "Autoflow",
  
  "image": "autoflow",

  "runArgs": [
    "--network=host",
    "--privileged",  // Required for hardware access
    "--env=DISPLAY=${localEnv:DISPLAY}",
    "--env=QT_X11_NO_MITSHM=1",
    "-v=/tmp/.X11-unix:/tmp/.X11-unix"
  ],
  
   "workspaceFolder": "/workspace",

   "mounts": [
    "source=${env:HOME}/Desktop/Autoflow,target=/workspace,type=bind"
  ],
  
  "extensions": [
    "ms-iot.vscode-ros-robotics",
    "ms-python.python"
  ],

  "settings": {
    "terminal.integrated.profiles.linux": {
      "bash": {
        "path": "/bin/bash"
      }
    },
    "terminal.integrated.defaultProfile.linux": "bash"
  },
  
}
```
#### open project in Dev Container
- open the project folder in Vscode.
- press F1 (or ctrl + SHIFT + P) and select "Dev Containers: Reopen in Container".  

Vscode will use the built image to open the container with the project inside it.

### Tests
At this point you can the GUI applications in the container with:
```bash
ros2 run rviz2 rviz2
```
to run rviz
or
```bash
ros2 launch ros_ign_gazebo ign_gazebo.launch.py ign_args:="-v 4 -r empty.sdf"
```
to launch Gazebo.  
gazebo can also be oppened by itself with the command: 
```bash
ign gazebo
```