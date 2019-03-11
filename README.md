# lm_demo_instructions

SSH instructions:

- TX2 SSH: ```ssh nvidia@192.168.1.10``` (IP might be different)

- Snapdragon Flight SSH: ```ssh linaro@192.168.1.40``` (IP might be different)

## Rover inspection demo

You will need 7 terminals for this. Two of them communicate with the TX2, one communicates with the snapdragon flight, and four terminal launch local nodes. The TX2 is already configured to communicate with ```roscore``` on the local machine.

- Terminal 1: roscore (I always leave this one running and never terminate it).

- Terminal 2: vicon + joystick (I always leve this one running and never terminate it).
```
roslaunch vicon vicon.launch
```

- Terminal 3: SSH into the TX2 and launch realsense camera + portrait mode + yolo:
```
roslaunch realsense2_camera rs_slam_ns.launch
```

- Terminal 4: SSH into the TX2 and launch ORB_SLAM2:
```
roslaunch ORB_SLAM2 rgbd_no_visualization.launch
```

- Terminal 5: SSH into the Snapdragon Flight and run PX4. You will hear beeps, confirming that px4 is running succesfully:
```
cd ~
sudo ./px4 mainapp.config
```

- Terminal 6: run px4_control. A RViz screen should show up. In this screen you should check the quad's position in Vicon frame (confirming that vicon is seeing the quad), and two images on top: the image on the top left should be in color and displays features recognized by yolo. The image on the top right is in grayscale and displays ORB_SLAM feature recognition. Finally, you should push the Y button on the joystick and thrust with the directional to make sure that you can arm the quad. If you want the quad to hold position, push X on the joystick.
```
roslaunch px4_control lm_bilbo.launch
```

  - Suggestion: switch the quad to position mode and take it to a position that ORB_SLAM is already recognizing features on the rover.

- Terminal 7: if everything looks okay from the previous pre-flight checks, you can start the mission on the last terminal:
```
roslaunch mission_planner rover_inspection.launch
```

  - Note: if you see an error on this last terminal displaying ```[ERROR] [1551998184.729836557]: Trying to getState() when no goal is running. You are incorrectly using SimpleActionClient```, don't worry. This error message is not really an error and was removed from ROS in January 2019 (https://github.com/ros/actionlib/pull/97), but I didn't update ROS on this computer yet. 

- If you want to launch the mission again, stop the nodes running in terminals 5, 6, and 7, then launch them again in that same order (make sure to do the pre-flight checks in Terminal 6!!!!)
