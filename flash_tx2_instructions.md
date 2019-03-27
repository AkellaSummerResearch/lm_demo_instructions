# TX2 flash instructions

This document shows how to flash the TX2 with all dependencies needed for the Lockheed Martin project. I estimate that it takes around 4 hours (unconfirmed) to complete everything in this list.

- Flashing the TX2 with the Orbitty carrier

	- Follow the instructions in: ```https://github.com/NVIDIA-AI-IOT/jetson-trashformers/wiki/Jetson%E2%84%A2-Flashing-and-Setup-Guide-for-a-Connect-Tech-Carrier-Board```

	- The video within ```http://connecttech.com/flashing-nvidia-jetson-tx2-tx1-module/``` is also useful for clarifying missing pieces. Note that the video does not show how to install important packages, such as CUDA (these are covered at the end of the previous link).
	
- Network settings (change the IP according with desired IP)

	- File within ```/etc/network/interfaces```

	```
	# interfaces(5) file used by ifup(8) and ifdown(8)
	# Include files from /etc/network/interfaces.d:
	source-directory /etc/network/interfaces.d
	```

	- File within ```/etc/network/interfaces.d/eth0```

	```
	auto eth0
	iface eth0 inet static
	address 192.168.1.10
	netmask 255.255.255.0
	gateway 192.168.1.1
	dns-nameservers 8.8.8.8
	```
	
	- File within ```/etc/resolv.conf``` (you can create it if it doesn't exist):
	
	```
	nameserver 8.8.4.4
	nameserver 8.8.8.8
	```

	- Reboot for changes to have an effect: ```sudo reboot```.

- Update and upgrade everything in the TX2

```
sudo apt update
sudo apt upgrade
```

- Install terminator (optional)

```
sudo apt install terminator
```

- Install barrier (optional: barrier allows mouse and keyboard on the jetson to be commanded within the network):

```
sudo apt install git cmake make xorg-dev g++ libcurl4-openssl-dev \
                 libavahi-compat-libdnssd-dev libssl-dev libx11-dev \
                 libqt4-dev qtbase5-dev xdotool
git clone https://github.com/AkellaSummerResearch/barrier
cd barrier
./clean_build.sh
cd build
sudo make install
```

	- Run barrier once to save fingerprint

	```
	./barrier/build/bin/barrier
	```

	- Configure barrier to start with terminator

		- Right-click on terminator window, click on Preferences, within Layouts add Custom command to desired window for barrier to run on. You will need two windows: on one, choose the following command (makes mouse visible on startup) ```gsettings set org.gnome.settings-daemon.plugins.cursor active false```, while the following command goes on the second one: ```./barrier/build/bin/barrierc -f --enable-crypto 192.168.1.200```

	- Make terminator open on startup: open ```Startup Applications``` and click on Add. On the desired command, just type ```terminator```, which is the command line to start Terminator.

- Install librealsense (originally obtained from https://www.jetsonhacks.com/2018/07/10/librealsense-update-nvidia-jetson-tx-dev-kits/)

	- Download the ```buildLibrealsense2TX``` folder from https://utexas.app.box.com/folder/64528736446.

	- Before running any executable, give execution permissions to all .sh files within ```buildLibrealsense2TX``` and within ```buildLibrealsense2TX/scripts``` (```chmod +x+u <filename>.sh)```. Before installing the realsense library, make sure to leave the realsense camera unplugged from the TX2!

	```
	./buildPatchedKernelTX.sh
	./installLibrealsense.sh
	```

	- Test the realsense:

	``` 
	cd /usr/local/bin
	./realsense-viewer
	```

- Install realsense ROS packages (originally obtained from https://www.jetsonhacks.com/2018/07/10/librealsense-update-nvidia-jetson-tx-dev-kits/)

	- Install ROS:

	```
	git clone https://github.com/jetsonhacks/installROSTX2.git
	cd installROSTX2
	./installROS.sh -p ros-kinetic-desktop -p ros-kinetic-rgbd-launch
	./setupCatkinWorkspace.sh
	```

	- Download the ```installRealSenseROSTX2``` folder from https://utexas.app.box.com/folder/64528654434.

	```
	./installRealSenseROS.sh
	cd ~/catkin_ws/src
	git clone https://github.com/AkellaSummerResearch/realsense.git
	cd ~/catkin_ws
	catkin_make -DCMAKE_BUILD_TYPE=Release
	```

	- Test the ROS node:

	```
	roslaunch realsense2_camera rs_rgbd.launch
	rosrun image_view image_view image:=/camera/color/image_raw
	```

- Install all other ROS nodes

	- Nodes to be installed within catkin_ws:

	```
	cd ~/catkin_ws/src
	git clone https://github.com/AkellaSummerResearch/batch_pose_estimator.git
	git clone https://github.com/marcelinomalmeidan/image_filters.git
	git clone https://github.com/radionavlab/mg_msgs.git
	git clone --recursive https://github.com/AkellaSummerResearch/darknet_ros.git
	catkin_make -DCMAKE_BUILD_TYPE=Release
	```

	- Install ORB-SLAM2 (this is not within catkin_ws)

	- Add the following line to ```~/.bashrc```:

	```
	export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB_SLAM2/Examples/ROS
	```	

	- Install ORB-SLAM2

	```
	sudo apt-get install libglew-dev
	cd ~
	git clone https://github.com/stevenlovegrove/Pangolin.git
	cd Pangolin
	mkdir build
	cd build
	cmake ..
	cmake --build .
	cd ~
	git clone https://github.com/marcelinomalmeidan/ORB_SLAM2
	source ~/.bashrc
	cd ORB_SLAM2
	./build.sh
	```