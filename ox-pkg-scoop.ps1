##########################################################
# config
##########################################################

# path
$env:SCOOP = 'C:\Scoop'

$Global:OX_OXYGEN.oxs = "$env:OXIDIZER\defaults\Scoopfile.txt"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\install")) {
    mkdir "$env:OX_BACKUP\install"
}
$Global:OX_OXIDE.bks = "$env:OX_BACKUP\install\Scoopfile.json"

function up_scoop {
    echo "Update Scoop by $($Global:OX_OXIDE.bks)"
    scoop import $($Global:OX_OXIDE.bks)
}

function back_scoop {
    echo "Backup Scoop to $($Global:OX_OXIDE.bks)"
    scoop export > $($Global:OX_OXIDE.bks)
}

##########################################################
# packages
##########################################################

Remove-Item alias:sls -Force -ErrorAction SilentlyContinue

function sis { scoop install $args }
function sus { scoop uninstall $args }
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
