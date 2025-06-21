##########################################################
# config
##########################################################

# system files
$Global:OX_ELEMENT.nj = "$HOME/.npmrc"
# backup files
if ([string]::IsNullOrEmpty("$Global:OX_BACKUP/javascript")) {
    mkdir "$Global:OX_BACKUP/javascript"
}

if (Get-Command pnpm -ErrorAction SilentlyContinue ) {
    $Global:OX_NPM = 'pnpm'
}
elseif (Get-Command npm -ErrorAction SilentlyContinue ) {
    $Global:OX_NPM = 'npm'
}
else {
    Write-Output 'No nodejs package manager found'
}

function up_node {
    Write-Output "Update Node by $($Global:OX_OXIDE.bknjx)"
    $pkgs = (cat $($Global:OX_OXIDE.bknjx) | tr '\n' ' ')
    Write-Output "Installing $pkgs"
    Invoke-Expression ". $Global:OX_NPM install -g $pkgs --force"
}

function back_node {
    Write-Output "Backup Node to $($Global:OX_OXIDE.bknjx)"
    . $Global:OX_NPM list -g | rg -o '\w+@' | tr -d '@' > "$($Global:OX_OXIDE.bknjx)"
}

##########################################################
# packages
##########################################################

function ncf { . $Global:OX_NPM config $args }
function nis { . $Global:OX_NPM install $args }
function nus {
    param ( $cmd )
    Switch ( $cmd ) {
        pnpm { pnpm remove $args }
        npm { npm uninstall $args }
    }
}
function nup { . $Global:OX_NPM update $args }
function nst { . $Global:OX_NPM outdated }
function nsc { . $Global:OX_NPM search $args }
function ncl {
    param ( $cmd )
    Switch ( $cmd ) {
        pnpm { pnpm cache delete $args }
        npm { npm cache clean -f $args }
    }
}

##########################################################
# info
##########################################################

function nh { . $Global:OX_NPM help $args }
function nif { npm info }
function nls { . $Global:OX_NPM list $args }
function nlv { . $Global:OX_NPM list --depth 0 }
function nck { . $Global:OX_NPM doctor }

##########################################################
# project
##########################################################

function nii { . $Global:OX_NPM init $args }
function nr { . $Global:OX_NPM run $args }
function nts { . $Global:OX_NPM test $args }
function npb { . $Global:OX_NPM publish $args }
function nfx {
    . $Global:OX_NPM audit fix $args
    . $Global:OX_NPM audit $args
}
