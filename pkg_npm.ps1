##########################################################
# config
##########################################################

# system files
$Global:OX_ELEMENT.nj = "$HOME/.npmrc"
# backup files
if ([string]::IsNullOrEmpty("$Global:OX_BACKUP/javascript")) {
    mkdir "$Global:OX_BACKUP/javascript"
}

$bknjx = $Global:OX_BACKUP + '/' + $Global:OX_OXIDE.bknjx
function up_node {
    Write-Output "Update Node by $bknjx"
    $pkgs = (cat $bknjx | tr '\n' ' ')
    Write-Output "Installing $pkgs"
    Invoke-Expression "npm install -g $pkgs --force"
}

function back_node {
    Write-Output "Backup Node to $bknjx"
    npm list -g | rg -o '\w+@' | tr -d '@' > "$bknjx"
}

##########################################################
# packages
##########################################################

function ncf { npm config $args }
function nis { npm install $args }
function nus { npm uninstall $args }
function nup { npm update $args }
function nst { npm outdated }
function nsc { npm search $args }
function ncl { npm cache clean -f $args }

##########################################################
# info
##########################################################

function nh { npm help $args }
function nif { npm info }
function nls { npm list $args }
function nlv { npm list --depth 0 }
function nck { npm doctor }

##########################################################
# project
##########################################################

function nii { npm init $args }
function nr { npm run $args }
function nts { npm test $args }
function npb { npm publish $args }
function nfx {
    npm audit fix $args
    npm audit $args
}
