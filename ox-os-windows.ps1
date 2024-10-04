##########################################################
# config
##########################################################

function open { explorer $args }

##########################################################
# main
##########################################################

function clean {
    param ( $obj )
    Switch ( $obj ) {
        sdl { rm -r $env:SCOOP\cache }
        Default { Clear-RecycleBin -Confirm }
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

# backup files
$Global:OX_OXIDE.bkw = "$env:OX_BACKUP\win\Wingetfile.json"

function up_winget {
    echo "Update Scoop by $($Global:OX_OXIDE.bkw)"
    winget import -i $Global:OX_OXIDE.bkw
}
function back_winget {
    echo "Backup Scoop by $($Global:OX_OXIDE.bkw)"
    winget export -o $Global:OX_OXIDE.bkw
}

function wis { winget install $args }
function wus { winget uninstall $args }
function wls { winget list $args }
function wif { winget show $args }
function wifs { winget --info }
function wsc { winget search $args }
function wup {
    if (-not $args) { winget upgrade * }
    else { winget upgrade $args }
}

function wups { winget source update $args }

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

function wslii { wsl --install }

function wslis { param ( $dist ) wsl --install -d $dist }

function wslus { param ( $dist ) wslconfig /u $dist }
function wslls { wsl --list -v }
function wsllsa { wsl --list --online }

function wslset {
    param ( $ver )
    Switch ($ver) {
        { $ver -eq 2 } { 1 }
        Default { 2 }
    }
    wsl --set-version $ver
}

function wslcl {
    param ( $sys )
    Switch ( $sys ) {
        kali { $file = "C:\Users\Ci\AppData\Local\Packages\KaliLinux.54290C8133FEE_ey8k8hqnwqnmg\LocalState\ext4.vhdx" }
        Default { $file = "C:\Users\Ci\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\ext4.vhdx" }
    }
    diskpart
    Select-Object vdisk file=$file
    attach vdisk readonly
    compact vdisk
    detach vdisk
}
