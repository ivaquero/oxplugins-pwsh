##########################################################
# config
##########################################################

$Global:OX_OXYGEN.oxhx = "$env:OXIDIZER\defaults\helix.toml"
# config files
$Global:OX_ELEMENT.hx = "$env:APPDATA\helix\config.toml"
$Global:OX_ELEMENT.hxl = "$env:APPDATA\helix\languages.toml"

##########################################################
# main
##########################################################

function hxh { hx --help }
function hxck { hx --health $args }

# specific
function hxtt { hx --tutor }
