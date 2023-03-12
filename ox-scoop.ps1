##########################################################
# config
##########################################################

Import-Module "$(dirname $(dirname $(Get-Command scoop).Path))\modules\scoop-completion" -ErrorAction SilentlyContinue

$Global:OX_OXYGEN.oxs = "$env:OXIDIZER\defaults\Scoopfile.txt"
# backup files
$Global:OX_OXIDE.bks = "$env:OX_BACKUP\install\Scoopfile.json"

##########################################################
# config
##########################################################

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

function sisp {
    $num = echo $args | wc -l
    if ( $num -ge 1 ) {
        pueue group add scoop_install
        pueue parallel $num -g scoop_install

        ForEach ($pkg in $args) {
            echo "Installing $pkg"
            pueue add -g scoop_install "scoop install $pkg"
        }
        pueue wait -g scoop_install
        pueue status
    }
    else { scoop update --all }
}

function supp {
    $num = scoop status | wc -l
    if ( $num -ge 1 ) {
        pueue group add scoop_update
        pueue parallel $num -g scoop_update

        ForEach ($pkg in $args) {
            echo "Installing $pkg"
            pueue add -g scoop_update "scoop update $pkg"
        }
        pueue wait -g scoop_update
        pueue status
    }
    else { scoop update --all }
}

function scl {
    if (-not $args) { scoop cleanup --all --cache }
    else { scoop cleanup $args --cache }
}

function sdp { scoop depends $args[1] }
function sck { scoop checkup }
function ssc { scoop search $args[1] }
function sat { scoop config aria2-enabled true }
function saf { scoop config aria2-enabled false }

# info & version
function sif {
    Switch ( $args[1] ) {
        --json { scoop cat $args[2] }
        Default { scoop info $args[1] }
    }
}
function sst { scoop status }
function spn { scoop hold $args[1] }
function supn { scoop unhold $args[1] }

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

##########################################################
# mirrors
##########################################################

function smr {}
