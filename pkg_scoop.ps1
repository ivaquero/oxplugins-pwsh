##########################################################
# config
##########################################################

# path
$env:SCOOP = 'C:\Scoop'

# system files
$Global:OX_ELEMENT.s = "$HOME\.config\scoop\config.json"

function up_scoop {
    $bks = $Global:OX_BACKUP + '/' + $Global:OX_OXIDE.bks
    Write-Output "Update Scoop by $bks"
    scoop import $Global:OX_OXIDE.bks
}

function back_scoop {
    $bksx = $Global:OX_BACKUP + '/' + $Global:OX_OXIDE.bksx
    Write-Output "Backup Scoop to $bksx"
    scoop export --config > $bksx
}

##########################################################
# packages
##########################################################

Remove-Item alias:sls -Force -ErrorAction SilentlyContinue

function sis { scoop install $args }
function sus { scoop uninstall $args }
function sris {
    scoop uninstall $args
    scoop install $args
}
function sls { scoop list }
function sups { scoop update }

function sup {
    if (-not $args) { scoop update --all }
    else { scoop update $args }
}

function scl {
    if (-not $args) { scoop cleanup --all --cache }
    else { scoop cleanup $args --cache }
}

function sdp { scoop depends $args[0] }
function sck { scoop checkup }
function ssc { scoop search $args[0] }
function sat { scoop config aria2-enabled true }
function saf { scoop config aria2-enabled false }

# info & version
function sif { scoop info $args[0] }
function sst { scoop status }
function spn { scoop hold $args[0] }
function spnr { scoop unhold $args[0] }

##########################################################
# extension
##########################################################

function sxa { scoop bucket add $args }
function sxrm { scoop bucket rm $args }
function sxls { scoop bucket list }

##########################################################
# project
##########################################################

function sii { param ( $pkg ) scoop create $pkg }
function sca { param ( $pkg ) scoop cat $pkg }
