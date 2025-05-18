##########################################################
# config
##########################################################

# system files
$env:OX_ELEMENT.nj = "$HOME/.npmrc"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP/javascript")) {
    mkdir "$env:OX_BACKUP/javascript"
}

if (Get-Command pnpm -ErrorAction SilentlyContinue ) {
    $env:OX_NPM = "pnpm"
}
elseif (Get-Command npm -ErrorAction SilentlyContinue ) {
    $env:OX_NPM = "npm"
}
else {
    Write-Output "No nodejs package manager found"
}

function up_node {
    Write-Output "Update Node by $($env:OX_OXIDE.bknjx)"
    $pkgs = (cat $($env:OX_OXIDE.bknjx) | tr "\n" " ")
    Write-Output "Installing $pkgs"
    Invoke-Expression ". $env:OX_NPM install -g $pkgs --force"
}

function back_node {
    Write-Output "Backup Node to $($env:OX_OXIDE.bknjx)"
    . $env:OX_NPM list -g | rg -o '\w+@' | tr -d '@' > "$($env:OX_OXIDE.bknjx)"
}

##########################################################
# packages
##########################################################

function ncf { . $env:OX_NPM config $args }
function nis { . $env:OX_NPM install $args }
function nus {
    param ( $cmd )
    Switch ( $cmd ) {
        pnpm { pnpm remove $args }
        npm { npm uninstall $args }
    }
}
function nup { . $env:OX_NPM update $args }
function nst { . $env:OX_NPM outdated }
function nsc { . $env:OX_NPM search $args }
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

function nh { . $env:OX_NPM help $args }
function nif { npm info }
function nls { . $env:OX_NPM list $args }
function nlv { . $env:OX_NPM list --depth 0 }
function nck { . $env:OX_NPM doctor }

##########################################################
# project
##########################################################

function nii { . $env:OX_NPM init $args }
function nr { . $env:OX_NPM run $args }
function nts { . $env:OX_NPM test $args }
function npb { . $env:OX_NPM publish $args }
function nfx {
    . $env:OX_NPM audit fix $args
    . $env:OX_NPM audit $args
}
