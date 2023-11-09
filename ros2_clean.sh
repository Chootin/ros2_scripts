#! /bin/bash

# Alec Tutin - 2023-05-11
#
# This script is best used with an alias which also clears a few environment variables.
# Add something like this to your ~/.bash_aliases
# alias ros2_clean="/path/to/script/ros2_clean.sh; export CMAKE_PREFIX_PATH=\"\"; export AMENT_PREFIX_PATH=\"\"; source /opt/ros/distro/setup.bash"

if [ -d "build" ] && [ -d "install" ] && [ -d "log" ]; then
	rm -rf build install log
else
	echo "Unable to verify the current working directory is a complete ROS2 workspace... Aborting!"
fi
