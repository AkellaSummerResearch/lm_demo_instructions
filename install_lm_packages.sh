CATKIN_PATH='~/lockheed_ws'

# Create catkin workspace
eval mkdir -p $CATKIN_PATH
eval cd $CATKIN_PATH
catkin_make

# Install dependencies for min snap path planner ------------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/AkellaSummerResearch/nlopt.git 
git clone https://github.com/AkellaSummerResearch/mav_comm.git
git clone https://github.com/AkellaSummerResearch/catkin_simple.git
git clone https://github.com/AkellaSummerResearch/eigen_catkin.git
git clone https://github.com/radionavlab/mg_msgs.git
eval cd $CATKIN_PATH
catkin_make

eval cd $CATKIN_PATH/src
git clone https://github.com/AkellaSummerResearch/glog_catkin.git
eval cd glog_catkin
git checkout 314b53e 
eval cd $CATKIN_PATH
catkin_make

eval cd $CATKIN_PATH/src
git clone https://github.com/AkellaSummerResearch/eigen_checks.git
eval cd $CATKIN_PATH
catkin_make

# Install min snap path planner -----------------------------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/AkellaSummerResearch/mav_trajectory_generation.git
eval cd $CATKIN_PATH
catkin_make

# Install the desired versionm of mavros --------------------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/mavlink/mavros.git
eval cd $CATKIN_PATH/src/mavros
git checkout indigo-devel
eval cd $CATKIN_PATH
catkin_make

# Install the desired version of px4_control ----------------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/radionavlab/px4_control.git
eval cd $CATKIN_PATH/src/px4_control
git checkout lockheed_quads

# Install the desired version of joystick drivers -----------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/radionavlab/joystick_drivers.git
eval cd $CATKIN_PATH/src/joystick_drivers
git checkout indigo-devel
eval cd $CATKIN_PATH
catkin_make

# Install all other important packages ----------------------------------------------
eval cd $CATKIN_PATH/src
git clone https://github.com/AkellaSummerResearch/tf_publisher
git clone https://github.com/radionavlab/vicon.git
git clone https://github.com/AkellaSummerResearch/batch_pose_estimator.git
git clone https://github.com/AkellaSummerResearch/capture_waypoints.git
git clone https://github.com/AkellaSummerResearch/yolo_triangulation.git
git clone --recursive https://github.com/AkellaSummerResearch/darknet_ros.git
git clone https://github.com/AkellaSummerResearch/vision_opencv.git
git clone https://github.com/marcelinomalmeidan/image_filters.git 
git clone https://github.com/marcelinomalmeidan/mapper.git
git clone https://github.com/AkellaSummerResearch/p4_ros.git
git clone https://github.com/AkellaSummerResearch/mission_planner.git
eval cd $CATKIN_PATH
catkin_make