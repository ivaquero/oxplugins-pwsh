##########################################################
# Proxy Utils
##########################################################

# proxy
function px {
    param ( $the_port )
    if ( $(echo $the_port | wc -L) -lt 2 ) {
        $port = $Global:OX_PROXY.$the_port
    }
    else {
        $port = $the_port
    }
    echo "using port $($Global:OX_PROXY.$the_port)"
    $env:https_proxy = "http://127.0.0.1:$port"
    $env:http_proxy = "http://127.0.0.1:$port"
    $env:all_proxy = "socks5://127.0.0.1:$port"
}

function pxq {
    echo 'unset all proxies'
    $env:https_proxy = ''
    $env:http_proxy = ''
    $env:all_proxy = ''
}

# Turn on TLS 1.0, TLS 1.1, TLS 1.2, 和 TLS 1.3...
$secureProtocolsPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'
$secureProtocolsValue = 0x2AA0

# Set SecureProtocols
New-ItemProperty -Path $secureProtocolsPath -Name 'SecureProtocols' -Value $secureProtocolsValue -PropertyType DWord -Force -ErrorAction Stop

# Stop IE proxy server
Set-ItemProperty -Path $secureProtocolsPath -Name 'ProxyEnable' -Value 0 -Force -ErrorAction Stop
