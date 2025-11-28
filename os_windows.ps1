##########################################################
# config
##########################################################

function open { explorer $args }

##########################################################
# main
##########################################################

function clean {
    param ( $obj )
    switch ( $obj ) {
        WinGet { rm -r $env:WinGet\cache }
        default { Clear-RecycleBin -Confirm }
    }
}

function hide {
    $file = Get-Item $args[0] -Force
    $file.attributes = 'Hidden'
}

function shutdown { Stop-Computer -Force }
function restart { Restart-Computer -Force }
function which { (Get-Command $args[0]).Source }

##########################################################
# winget
##########################################################

# system files
$Global:OX_ELEMENT.w = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
# backup files
if ([string]::IsNullOrEmpty("$Global:OX_BACKUP\win")) {
    mkdir "$Global:OX_BACKUP\win"
}

function up_winget {
    $bkwx = $Global:OX_BACKUP + '/' + $Global:OX_OXIDE.bkwx
    Write-Output "Update WinGet by $bkwx"
    winget import -i $bkwx
}
function back_winget {
    $bkwx = $Global:OX_BACKUP + '/' + $Global:OX_OXIDE.bkwx
    Write-Output "Backup WinGet by $bkwx"
    winget export -s winget -o $bkwx
}

function wis { winget install $args }
function wus { winget uninstall $args }
function wls { winget list $args }
function wst { winget list --upgrade-available }
function wif { winget show $args }
function wifs { winget --info }
function wcl { rm -rfv "$HOME/AppData/Local/Temp/WinGet" }
function wsc { winget search $args }
function wup { winget upgrade $args }

function wcf { winget settings }

# extension
function wxa { param ( $repo ) winget source add $repo }
function wxrm { param ( $repo ) winget source remove $repo }
function wxls { param ( $repo ) winget source list }

function reset_msstore {
    # Turn on TLS 1.0, TLS 1.1, TLS 1.2, 和 TLS 1.3...
    $secureProtocolsPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'
    $secureProtocolsValue = 0x2AA0

    # Set SecureProtocols (the following line returns msg)
    New-ItemProperty -Path $secureProtocolsPath -Name 'SecureProtocols' -Value $secureProtocolsValue -PropertyType DWord -Force -ErrorAction Stop

    # Stop IE proxy server
    Set-ItemProperty -Path $secureProtocolsPath -Name 'ProxyEnable' -Value 0 -Force -ErrorAction Stop
}

##########################################################
# wsl
##########################################################

function wslis {
    if (-not $args) { wsl --install }
    else { wsl --install -d $args }
}

function wslus { param ( $dist ) wslconfig /u $dist }
function wslls { wsl --list -v }
function wsllsa { wsl --list --online }

function wslcl {
    param ( $dist )
    switch ( $dist ) {
        kali { $file = "$env:LOCALAPPDATA\Packages\KaliLinux.54290C8133FEE_ey8k8hqnwqnmg\LocalState\ext4.vhdx" }
        default { $file = "$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx" }
    }
    diskpart
    Select-Object vdisk file=$file
    attach vdisk readonly
    compact vdisk
    detach vdisk
}
