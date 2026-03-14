# Autoflow

### Introduction 
  Autoflow is a project in which in a team of two we have decided to make a small robot with the simple objective to follow a target.
  Here I will give a cleaned version of our work  and dive deeper on parts for which we did not had time to go through.
  In the main project the robot equipped three sensors (DWM1001_DEV) to detect a forth one by trilateration.
  We will first fully simulate this version and later upgrade to object detection in order to follow the target.


## V1 (DWM1001_DEV)

In this version, the car will have two motorized back wheels and two free wheels in the front. It will be turning thanks to the motorized wheels.  
And as said three captors will be used to triangulate the position of a fourth one. The car will be following it and a Lidar will be use for obstacle detection and avoidance.

### The car 

#### Frame 
A real version of this project already exist we modeled and manufactured it. 
You will be able to find the modeled parts in the [CAD](https://github.com/YOUSSNDR/Autoflow/tree/main/CAD) folder.

#### ELectronics
For the different electronic connection, they will be available in the [Electronic](https://github.com/YOUSSNDR/Autoflow/tree/main/Electronic) folder.
The different electronic component needed for this project are the following:

|Module|pieces|Tension(V)|Intensity(A)|
|------|------|---------|-------|
|[DWM1001_DEV](https://www.mouser.fr/ProductDetail/Qorvo/DWM1001-DEV?qs=TiOZkKH1s2T4sar5INj0ew%3D%3D&srsltid=AfmBOorqy5ZnZvl6puMKr_-_Af3t4eY71g53g9BRfKSXkqYK-x9jgRT1)|3|5|0.5|
|[LIDAR](https://www.amazon.fr/Slamtec-RPLIDAR-num%C3%A9risation-bstacles-navigation/dp/B07TJW5SXF)|1|5|0.23|
|[MPU6050](https://www.gotronic.fr/art-module-6-dof-sen-mpu6050-31492.htm)|1|5|0.02|
|[MOTOR+encoder](https://www.gotronic.fr/art-kit-moteur-encodeur-fit0450-27583.htm)|2|6|0.35|
|[Raspberry](https://www.amazon.fr/Raspberry-Pi-4595-mod%C3%A8les-Go/dp/B09TTNF8BT/ref=asc_df_B09TTNF8BT/?tag=googshopfr-21&linkCode=df0&hvadid=701511851267&hvpos=&hvnetw=g&hvrand=5788597801172693301&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9054962&hvtargid=pla-1679572971964&psc=1&mcid=e9453b632e653cdca350de98083c3cb0&gad_source=1)|1|5|3|

The battery will have to supply a voltage of 6V and as we aim to fully use the robot for half an hour, We will need a capacity of at least 2,73A/h.(We need at least 16,38Wh).   *(this is purely theoric)

#### src

The [src](https://github.com/YOUSSNDR/Autonomouscar/tree/main/ros/src) directory will be gathering all packages used in this project.

the Autoflow package can be used to launch a simulation of the robot.
The robot package contain the programs to use the real robot.

## Container

To work on those project we will be using a container allowing us to use the wanted version of ROS2 for our project while avoiding conflicts on our Host system. 
This will also allow anyone to just download this repository and have a simulation ready project.

You will find info on how this container was made and how to use it in the [Container folder](https://github.com/YOUSSNDR/Autoflow/tree/main/Container)