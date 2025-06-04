##########################################################
# Proxy Utils
##########################################################

$env:OX_PROXY = $env:OX_CUSTOM.proxy_ports
function pxy {
    param ( $the_port )
    if ( $the_port.Length -lt 0 ) {
        Write-Output 'unset all proxies'
        $env:https_proxy = ''
        $env:http_proxy = ''
        $env:all_proxy = ''
    }
    else {
        if ( $the_port.Length -lt 2 ) {
            $port = $env:OX_PROXY.$the_port
        }
        else {
            $port = $the_port
        }
        Write-Output "using port $port"
        $env:https_proxy = "http://127.0.0.1:$port"
        $env:http_proxy = "http://127.0.0.1:$port"
        $env:all_proxy = "socks5://127.0.0.1:$port"
    }
}
