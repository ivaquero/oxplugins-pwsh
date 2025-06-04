##########################################################
# config
##########################################################


##########################################################
# packages
##########################################################

function pxh { pixi $args --help }
function pxcf { pixi config $args }
function pxi { pixi install $args }
function pxis { pixi install $args }
function pxus { pixi uninstall $args }
function pxup { pixi update $args }

##########################################################
# info
##########################################################

function pxsc { pixi search $args }
function pxls { pixi list $args }
function pxlv { pixi tree | sort }

##########################################################
# project
##########################################################

function pxii { pixi init $args }
function pxr { pixi run $args }
