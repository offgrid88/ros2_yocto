mkdir "ros_build"
cd "ros_build"

git clone -b build --single-branch git@github.com:ros/meta-ros build
mkdir conf
ln -snf ../conf build/.

# Select a configuration based on the OpenEmbedded DISTRO (ros1, ros2, or webos), the ROS distro (melodic, noetic, dashing,
# eloquent, foxy, galactic, or rolling), and the OpenEmbedded release series (dunfell, gatesgarth, hardknott, honister, or
# kirkstone) that you wish to build:
#
# distro=ros1
distro=ros2
# distro=webos (oe_release_series=dunfell only)
#
# ros_distro=melodic
# ros_distro=noetic
# ros_distro=dashing ("best effort" support)
# ros_distro=eloquent ("best effort" support)
ros_distro=foxy
# ros_distro=galactic
# ros_distro=rolling
#
oe_release_series=dunfell
# oe_release_series=gatesgarth ("best effort" support)
# oe_release_series=hardknott
# oe_release_series=honister
# oe_release_series=kirkstone
cfg=$distro-$ros_distro-$oe_release_series.mcf
cp build/files/$cfg conf/.

# Clone the OpenEmbedded metadata layers and generate conf/bblayers.conf .
build/scripts/mcf -f conf/$cfg

# Set up the shell environment for this build and create a conf/local.conf . We expect all of the variables below to be unset.
unset BDIR BITBAKEDIR BUILDDIR OECORELAYERCONF OECORELOCALCONF OECORENOTESCONF OEROOT TEMPLATECONF
source openembedded-core/oe-init-build-env

# The current directory is now the build directory; return to the original.
cd -

# An OpenEmbedded build produces a number of types of build artifacts, some of which can be shared between builds for
# different OpenEmbedded DISTRO-s and ROS distros. Create a common artifacts directory on the separate disk under which all
# the build artifacts will be placed. The edits to conf/local.conf done below will set TMPDIR to be a subdirectory of it.
mkdir -p /opt/raspberry/ros_build/ros2
