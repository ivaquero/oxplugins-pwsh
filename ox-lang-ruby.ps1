##########################################################
# config
##########################################################

##########################################################
# packages
##########################################################

function rbis { gem install $args }
function rbus { gem uninstall $args }
function rbls { gem list $args }
function rbud { gem update $args }
function rbsc { gem search $args }
function rbcl { gem cleanup $args }
function rbck { gem check $args }
function rbif { gem info $args }
function rbdp { gem dependency $args }
function rbct { gem contents $args }

##########################################################
# project
##########################################################

function rbb { gem build $args }
