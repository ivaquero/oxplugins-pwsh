##########################################################
# ros2
##########################################################

function r2b { colcon build && source install/local_setup.sh }
function r2r { ros2 run $args }
function r2l { ros2 launch $args }

##########################################################
# pkg
##########################################################

function r2p { ros2 pkg $args }
function r2pls { ros2 pkg list $args }
function r2pcrc { ros2 pkg create --build-type ament_cmake $args }
function r2pcrpy { ros2 pkg create --build-type ament_python $args }

##########################################################
# topic
##########################################################

function r2t { ros2 topic $args }
function r2tbw { ros2 topic bw $args }
function r2tls { ros2 topic list $args }
function r2tif { ros2 topic info $args }
function r2te { ros2 topic echo $args }
function r2tp { ros2 topic pub $args }

##########################################################
# service
##########################################################

function r2s { ros2 service $args }
function r2sls { ros2 service list $args }
function r2sty { ros2 service type $args }
function r2sca { ros2 service call $args }

##########################################################
# interface
##########################################################

function r2i { ros2 interface $args }
function r2ils { ros2 interface list }
function r2ish { ros2 interface show $args }
function r2ip { ros2 interface package $args }

##########################################################
# action
##########################################################

function r2a { ros2 action $args }
function r2als { ros2 action list }
function r2aif { ros2 action info $args }
function r2asg { ros2 action send_goal $args }

##########################################################
# param
##########################################################

function r2pm { ros2 param $args }
function r2pmif { ros2 param describe $args }
function r2pms { ros2 param set $args }
function r2pmg { ros2 param get $args }
function r2pmd { ros2 param dump $args }
function r2pml { ros2 param load $args }
