##########################################################
# config
##########################################################

# system files
if (Test-Path -Path "$env:SCOOP\persist\vscode\data\user-data") {
    $Global:VSCODE_DATA = "$env:SCOOP\persist\vscode\data\user-data"
}
elseif (Test-Path -Path "$env:SCOOP\persist\vscode-win7\data\user-data") {
    $Global:VSCODE_DATA = "$env:SCOOP\persist\vscode-win7\data\user-data"
}

$Global:OX_ELEMENT.vs = "$Global:VSCODE_DATA\User\settings.json"
$Global:OX_ELEMENT.vsk = "$Global:VSCODE_DATA\User\keybindings.json"
$Global:OX_ELEMENT.vss_ = "$Global:VSCODE_DATA\User\snippets"

# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\vscode")) {
    mkdir "$env:OX_BACKUP\vscode"
}

function up_vscode {
    echo "Update VSCode extensions by $($Global:OX_OXIDE.bkvsx)"
    $exts = (code --list-extensions)
    $file = (cat $($Global:OX_OXIDE.bkvsx))
    $num = (cat $($Global:OX_OXIDE.bkvsx) | wc -l)

    pueue group add vscode_update
    pueue parallel $num -g vscode_update

    ForEach ( $line in $file ) {
        if (echo $exts | rg $line) {
            echo "Extension $line is already installed."
        }
        else {
            echo "Installing $line"
            pueue add -g vscode_update " code --install-extension '$line'"
        }
    }
    sleep 3
    pueue status
}

function back_vscode {
    echo "Backup VSCode extensions to $($Global:OX_OXIDE.bkvsx)"
    code --list-extensions > "$($Global:OX_OXIDE.bkvsx)"
}

##########################################################
# Cache
##########################################################

function vscl {
    echo "Cleaning up VSCode Cache.`n"
    rm -rfv $VSCODE_DATA\Cache\*
    echo "Cleaning up VSCode Obselete History.`n"
    rm -rfv $VSCODE_DATA\User\History\*
    echo "Cleaning up VSCode Obselete Profiles.\n"
    rm -rfv $VSCODE_DATA\User\profiles\-*

    Switch ( $args[1] ) {
        -a {
            echo "Cleaning up VSCode Workspace Storage.`n"
            rm -rfv $VSCODE_DATA\User\workspaceStorage\*
        }
    }
}

##########################################################
# extensions
##########################################################

function vsis { code --install-extension $args }
function vsus { code --uninstall-extension $args }
function vsls { code --list-extensions $args }

##########################################################
# integration
##########################################################

# shell
if ($env:TERM_PROGRAM -eq 'vscode') { . "$(code --locate-shell-integration-path pwsh)" }
