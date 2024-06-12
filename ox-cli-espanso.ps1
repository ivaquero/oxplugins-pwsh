##########################################################
# config
##########################################################

# system files
Switch ($env:OS) {
    "*Darwin* | *Ubuntu* | *Debian* | *WSL*" {
        $Global:ESPANSO_DATA = "$env:APPDATA\espanso"
    }
    "*MINGW* | *Windows*" {
        if (Test-Path -Path "$env:SCOOP/shims/espansod") {
            $Global:ESPANSO_DATA = "$env:SCOOP\current\.espanso"
        }
    }
}

$Global:OX_ELEMENT.es = "$Global:ESPANSO_DATA\config\default.yml"
$Global:OX_ELEMENT.esb = "$Global:ESPANSO_DATA\match\base.yml"
$Global:OX_ELEMENT.esx_ = "$Global:ESPANSO_DATA\match\packages"

# backup files
$Global:OX_OXIDE.bkes = "$env:OX_BACKUP\espanso\config\default.yml"
$Global:OX_OXIDE.bkesb = "$env:OX_BACKUP\espanso\match\base.yml"
$Global:OX_OXIDE.bkesx_ = "$env:OX_BACKUP\espanso\match\packages"

##########################################################
# packages
##########################################################

function esis { espansod package install $args }
function esus { espansod package uninstall $args }
function esls { espansod package list }

function esup {
    param ( $pkg )
    if ([string]::IsNullOrEmpty($pkg)) {
        $pkgs = $(espansod package list | rg -o "\w+.*\s-" | rg -o ".+*\w")
        ForEach ( $line in $pkgs ) {
            espansod package update $line
        }
    }
    else {
        espansod package update $pkg
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
