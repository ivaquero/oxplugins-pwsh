##########################################################
# config
##########################################################

$Global:OX_OXYGEN.oxhx = "$env:OXIDIZER\defaults\helix.toml"
# system files
$Global:OX_ELEMENT.hx = "$env:APPDATA\helix\config.toml"
$Global:OX_ELEMENT.hxl = "$env:APPDATA\helix\languages.toml"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\helix")) {
    mkdir "$env:OX_BACKUP\helix"
}
$Global:OX_OXIDE.hx = "$env:OX_BACKUP\helix\config.toml"
$Global:OX_OXIDE.hxl = "$env:OX_BACKUP\helix\languages.toml"

##########################################################
# main
##########################################################

function hxh { hx --help }
function hxck { hx --health $args }

# specific
function hxtt { hx --tutor }
