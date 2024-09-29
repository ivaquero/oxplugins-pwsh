##########################################################
# config
##########################################################

# system files
$Global:OX_ELEMENT.nj = "$HOME/.npmrc"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\javascript")) {
    mkdir "$env:OX_BACKUP\javascript"
}
$Global:OX_OXIDE.bknj = "$env:OX_BACKUP\javascript\.npmrc"
$Global:OX_OXIDE.bknjx = "$env:OX_BACKUP\javascript\node-pkgs.txt"

function up_node {
    echo "Update Node by $($Global:OX_OXIDE.bknjx)"
    $pkgs = (cat $($Global:OX_OXIDE.bknjx) | tr "\n" " ")
    echo "Installing $pkgs"
    Invoke-Expression "npm install -g $pkgs --force"
}

function back_node {
    echo "Backup Node to $($Global:OX_OXIDE.bknjx)"
    npm list -g | rg -o '\w+@' | tr -d '@' > "$($Global:OX_OXIDE.bknjx)"
}

##########################################################
# packages
##########################################################

function nh { npm help $args }
function ncf { npm config $args }
function nis { npm install $args }
function nus { npm uninstall $args }
function nisg { npm install -g $args }
function nusg { npm uninstall -g $args }
function nup { npm update $args }
function nupg { npm update -g $args }
function nst { npm outdated }
function nls { npm list $args }
function nlsg { npm list -g $args }
function nlv { npm list --depth 0 }
function nlvg { npm list --depth 0 -g }
function nck { npm doctor }
function nsc { npm search $args }
function ncl { npm cache clean -f }
function nif { npm info }

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

##########################################################
# packages
##########################################################

function yif { yarn info }

##########################################################
# project
##########################################################

function ycf { yarn config $args }
function yii { yarn init $args }
function yr { yarn run $args }
function ypb { yarn publish $args }
