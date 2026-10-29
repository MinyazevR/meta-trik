SUMMARY = "ROS2 Humble minimal package group for TRIK board"
DESCRIPTION = "\
    Minimal ROS2 Humble stack for TRIK. \
    Uses Cyclone DDS as the lightest available rmw middleware. \
    GUI tools, simulation and heavy-weight packages are excluded. \
"
LICENSE = "MIT"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

# Core ROS2 client libraries
ROS2_CORE = "\
    ros-core \
    rclcpp \
    rclpy \
"

# Cyclone DDS - lightest DDS implementation (~30 MB vs ~80 MB for Fast-DDS)
ROS2_MIDDLEWARE = "\
    cyclonedds \
    rmw-cyclonedds-cpp \
    rosidl-typesupport-fastrtps-c \
    rosidl-typesupport-fastrtps-cpp \
"

# Standard message types needed by virtually every ROS2 node
ROS2_MSGS = "\
    std-msgs \
    std-srvs \
    builtin-interfaces \
    rcl-interfaces \
    common-interfaces \
    action-msgs \
    lifecycle-msgs \
    composition-interfaces \
"

# Command-line tools for diagnostics
ROS2_TOOLS = "\
    ros2cli \
    ros2topic \
    ros2node \
    ros2service \
    ros2param \
    ros2run \
    ros2launch \
"

# Launch infrastructure
ROS2_LAUNCH = "\
    launch \
    launch-ros \
    launch-xml \
    launch-yaml \
"

RDEPENDS:${PN} = "\
    ${ROS2_CORE} \
    ${ROS2_MIDDLEWARE} \
    ${ROS2_MSGS} \
    ${ROS2_TOOLS} \
    ${ROS2_LAUNCH} \
"
