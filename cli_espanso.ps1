##########################################################
# config
##########################################################

# system files
if (Test-Path -Path "$env:SCOOP\shims\espansod.exe") {
    $Global:ESPANSO_DATA = "$env:SCOOP\persist\espanso\.espanso"
}
else {
    $Global:ESPANSO_DATA = "$env:APPDATA\espanso"
}

$Global:OX_ELEMENT.es = "$Global:ESPANSO_DATA\config\default.yml"
$Global:OX_ELEMENT.esb = "$Global:ESPANSO_DATA\match\base.yml"
$Global:OX_ELEMENT.esx_ = "$Global:ESPANSO_DATA\match\packages"

##########################################################
# packages
##########################################################

function esis { espansod package install $args }
function esus { espansod package uninstall $args }
function esls { espansod package list }

function esup {
    if (-not $args) {
        $pkgs = $(espansod package list | rg -o '\w+.*\s-' | rg -o '.+*\w')
        ForEach ( $line in $pkgs ) {
            espansod package update $line
        }
    }
    else {
        espansod package update $args
    }
}

##########################################################
# management
##########################################################

function ess { espansod start }
function esr { espansod restart }
function esst { espansod status }
function esq { espansod stop }

##########################################################
# main
##########################################################

function esa {
    param ( $path )
    touch $Global:ESPANSO_DATA\match\$path.yml
}
function esh { espansod help $args }
function esed { espansod edit $args }
