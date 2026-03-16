# Ros 

All the simulation will be happening in Ros2 more precisely the humble distrubution.  
The installation is already handled with the container configuration you can find here [container_creation]().

You will be finding here informations on how the ros2 workspace is made and some important comands.

## Create a workspace directory
For the project we had multiple workspace I will be recreating one regrouping everything we need.  
First we need to create the workspace from the terminal :
```bash
mkdir Autoflow_ws # create the workspace with the name we want
cd Autoflow_ws # go in it
mkdir src # make a src file
```

The "src" file will be containing all our nodes later and is needed to build the workspace.
We already have a ros2 global install for which we can use the nodes, this workspace will serve as an overlay, we will also have to source its setup.bash in order to use our custom nodes.

## Build the workspace
Now from the workspce directory in the terminal, we will use:
```bash
colcon build
```
This will fetch the code in the src folder then build and install nodes in the install folder.

*In the **install** folder will be the **setup.bash** file that we will need to source in order to use our nodes.*

there for we can add the following in our Dockerfile:
```Dockerfile
Run echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
```
Allowing us to source our workspace each time we open a terminal in our container

## Create Packages

For the different function of the robot we will have packeges.
for now the different packages will be for:
- robot controll "Autoflow_controller" (ways the robot will be controlled)
- robot vision "Autoflow_vision" (different ways the robot reper itself and its surroundings)
- robot path planning "Autoflow_Path_Planning" (The differents algorithms for path planning)
- robot simulation "Autoflow_simulation" (simulation of the robot)

To creat a package you have to be in the "src" file of the workspace and enter in the terminal: 
```bash
ros2 pkg create robot_name_function --build-type ament_python --dependencies rclpy # or ament_cmake
```
ament is the build system, ament_python will build a python package, ament_cmake a cpp one.  
--dependencies allows us to add all the packages and functionalities wich will be need to use in the package.
here we added rclpy which is the python library for ros2

This will create a packagefor which we can change the infos in the package.xml and setup.py. To make our nodes we will modify the __init__.py.