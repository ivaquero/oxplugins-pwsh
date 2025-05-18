##########################################################
# config
##########################################################

# system files
if (Test-Path -Path "$env:SCOOP\persist\vscode\data\user-data") {
    $Global:VSCODE_DATA = "$env:SCOOP\persist\vscode\data\user-data"
}

$env:OX_ELEMENT.vs = "$Global:VSCODE_DATA\User\settings.json"
$env:OX_ELEMENT.vsk = "$Global:VSCODE_DATA\User\keybindings.json"
$env:OX_ELEMENT.vss_ = "$Global:VSCODE_DATA\User\snippets"

# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\vscode")) {
    mkdir "$env:OX_BACKUP\vscode"
}

function back_vscode {
    $bkvs = $env:OX_OXIDE.bkvsx
    Write-Output "Backup VSCode extensions to $env:OX_BACKUP/$bkvs"
    code --list-extensions > "$env:OX_BACKUP/$bkvs"
}

##########################################################
# Cache
##########################################################

function vscl {
    Write-Output "Cleaning up VSCode Cache.`n"
    rm -rfv $Global:VSCODE_DATA\Cache\*
    Write-Output "Cleaning up VSCode Obselete History.`n"
    rm -rfv $Global:VSCODE_DATA\User\History\*
    Write-Output "Cleaning up VSCode Obselete Profiles.\n"
    rm -rfv $Global:VSCODE_DATA\User\profiles\-*

    Switch ( $args[1] ) {
        -a {
            Write-Output "Cleaning up VSCode Workspace Storage.`n"
            rm -rfv $Global:VSCODE_DATA\User\workspaceStorage\*
        }
    }
}

##########################################################
# extensions
##########################################################

function vsis { code --install-extension $args }
function vsus { code --uninstall-extension $args }
function vsls { code --list-extensions $args }
