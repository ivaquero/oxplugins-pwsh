##########################################################
# config
##########################################################

# system files
if (!(Test-Path -Path "$env:APPDATA\espanso")) {
    $Global:OX_APPHOME.es = "$env:SCOOP\current\.espanso"
}
else {
    $Global:OX_APPHOME.es = "$env:APPDATA\espanso"
}

$Global:OX_ELEMENT.es = "$($Global:OX_APPHOME.es)\config\default.yml"
$Global:OX_ELEMENT.esb = "$($Global:OX_APPHOME.es)\match\base.yml"
$Global:OX_ELEMENT.esx_ = "$($Global:OX_APPHOME.es)\match\packages"

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
    touch $($Global:OX_APPHOME.es)\match\$path.yml
}
function esh { espansod help $args }
function esed { espansod edit $args }
