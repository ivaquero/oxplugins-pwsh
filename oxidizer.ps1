if ([string]::IsNullOrEmpty($env:OXIDIZER)) {
    $env:OXIDIZER = "$HOME\oxidizer"
}

##########################################################
# Oxidizer Configuration Files
##########################################################

# plugins
$Global:OX_OXYGEN = @{
    'oxd' = "$env:OXIDIZER\defaults.ps1"
    'oxwz' = "$env:OXIDIZER\defaults\wezterm.lua"
    'oxps' = "$env:OXIDIZER\plugins-pwsh\ox-scoop.ps1"
    'oxpw' = "$env:OXIDIZER\plugins-pwsh\ox-windows.ps1"
    'oxpg' = "$env:OXIDIZER\plugins-pwsh\ox-git.ps1"
    'oxpc' = "$env:OXIDIZER\plugins-pwsh\ox-conda.ps1"
    'oxpbw' = "$env:OXIDIZER\plugins-pwsh\ox-bitwarden.ps1"
    'oxpcn' = "$env:OXIDIZER\plugins-pwsh\ox-conan.ps1"
    'oxpdk' = "$env:OXIDIZER\plugins-pwsh\ox-docker.ps1"
    'oxpes' = "$env:OXIDIZER\plugins-pwsh\ox-espanso.ps1"
    'oxpfm' = "$env:OXIDIZER\plugins-pwsh\ox-formats.ps1"
    'oxpjl' = "$env:OXIDIZER\plugins-pwsh\ox-julia.ps1"
    'oxpjn' = "$env:OXIDIZER\plugins-pwsh\ox-jupyter.ps1"
    'oxpnj' = "$env:OXIDIZER\plugins-pwsh\ox-node.ps1"
    'oxpns' = "$env:OXIDIZER\plugins-pwsh\ox-notes.ps1"
    'oxpnw' = "$env:OXIDIZER\plugins-pwsh\ox-network.ps1"
    'oxppu' = "$env:OXIDIZER\plugins-pwsh\ox-pueue.ps1"
    'oxprb' = "$env:OXIDIZER\plugins-pwsh\ox-ruby.ps1"
    'oxprs' = "$env:OXIDIZER\plugins-pwsh\ox-rust.ps1"
    'oxptl' = "$env:OXIDIZER\plugins-pwsh\ox-texlive.ps1"
    'oxput' = "$env:OXIDIZER\plugins-pwsh\ox-utils.ps1"
    'oxpvs' = "$env:OXIDIZER\plugins-pwsh\ox-vscode.ps1"
    'oxpwr' = "$env:OXIDIZER\plugins-pwsh\ox-weather.ps1"
}

##########################################################
# System Configuration Files
##########################################################

$Global:OX_ELEMENT = @{
    'ox' = "$env:OXIDIZER\custom.ps1"
    'vi' = "$HOME\.vimrc"
}

$Global:OX_OXIDE = @{}

##########################################################
# Load Plugins
##########################################################

# load system plugin
. $Global:OX_OXYGEN.oxw

# load custom plugins
. $Global:OX_ELEMENT.ox

ForEach ($plugin in $Global:OX_PLUGINS) {
    if (Test-Path $Global:OX_OXYGEN.$($plugin)) {
        . $Global:OX_OXYGEN.$($plugin)
    }
    else {
        echo "Plugin not found: $plugin"
    }
}

# load core plugins
$Global:OX_CORE_PLUGINS = @('oxps', 'oxput', 'oxpnw')

ForEach ($core_plugin in $Global:OX_CORE_PLUGINS) {
    . $Global:OX_OXYGEN.$($core_plugin)
}

##########################################################
# PowerShell Settings
##########################################################

$Global:OX_ELEMENT.ps = $PROFILE
$Global:OX_OXIDE.bkps = "$env:OX_BACKUP\shell\Profile.ps1"

##########################################################
# Oxidizer Management
##########################################################

# update Oxidizer
function upox {
    cd $env:OXIDIZER
    echo "Updating Oxidizer...`n"
    git fetch origin master
    git reset --hard origin/master

    if (!(Test-Path -Path "$env:OXIDIZER\plugins-pwsh")) {
        echo "`n`nCloning Oxidizer Plugins...`n"
        git clone --depth=1 https://github.com/ivaquero/oxplugins-pwsh.git $env:OXIDIZER\plugins-pwsh
    }
    else {
        cd "$env:OXIDIZER\plugins-pwsh"
        echo "`n`nUpdating Oxidizer Plugins...`n"
        git fetch origin main
        git reset --hard origin/main
    }

    cd $env:OXIDIZER
    $ox_change=$(git diff defaults.ps1)
    if ([string]::IsNullOrEmpty($ox_change)) {
        echo "`n`nDefaults changed, don't forget to update your custom.ps1 accordingly...`n"
        echo "Compare the difference using 'edf oxd'"
    }
    cd $HOME
}

##########################################################
# Starship
##########################################################

if (Get-Command starship -ErrorAction SilentlyContinue) {
    # system files
    $env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
    $Global:OX_ELEMENT.ss = $env:STARSHIP_CONFIG
    # backup files
    $Global:OX_OXIDE.ss = "$env:OX_BACKUP\shell\starship.toml"

    Invoke-Expression (&starship init powershell)
}

if ($Global:OX_STARTUP) {
    startup
}

##########################################################
# Extras
##########################################################

Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

Import-Module "$env:SCOOP\modules\scoop-completion"
