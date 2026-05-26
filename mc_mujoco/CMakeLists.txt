cmake_minimum_required(VERSION 3.22)

project(mc_rtc_tutorial_mujoco)

find_package(mc_mujoco REQUIRED)

add_subdirectory(ur5e_mj_description)
add_subdirectory(kinova_mj_description)
