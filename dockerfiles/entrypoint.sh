#!/bin/bash
set -e

source /opt/ros/humble/setup.bash

echo "--- Building colcon workspace ---"
cd /root/colcon_ws
colcon build
if [[ -f "/root/colcon_ws/install/setup.bash" ]]; then
    source "/root/colcon_ws/install/setup.bash"
fi
echo "--- Colcon workspace build complete ---"

echo "--- Compiling mc_robots ---"
mkdir -p /root/mc_robots/build
cd /root/mc_robots/build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
make install
echo "--- mc_robots compilation complete ---"

echo "--- Compiling controllers ---"
mkdir -p /root/mc_rtc_ws/build
cd /root/mc_rtc_ws/build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
make install
echo "--- controllers compilation complete ---"

echo "--- Compiling mc_mujoco ---"
mkdir -p /root/mc_mujoco/build
cd /root/mc_mujoco/build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
make install
echo "--- mc_mujoco compilation complete ---"

echo "--- Compiling mc_interface ---"
mkdir -p /root/mc_interface/build
cd /root/mc_interface/build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
make install
echo "--- mc_interface compilation complete ---"

if ! grep -q "ros/humble/setup.bash" ~/.bashrc 2>/dev/null; then
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
    echo "source /root/colcon_ws/install/setup.bash" >> ~/.bashrc
fi
if ! grep -q "ros/humble/setup.zsh" ~/.zshrc 2>/dev/null; then
    echo "source /opt/ros/humble/setup.zsh" >> ~/.zshrc
    echo "source /root/colcon_ws/install/setup.zsh" >> ~/.zshrc
fi

exec "$@"
