##########################################################
# Proxy Utils
##########################################################

# proxy
function pxy {
    param ( $the_port )
    if ( $(echo $the_port | wc -L) -lt 0 ) {
        echo 'unset all proxies'
        $env:https_proxy = ''
        $env:http_proxy = ''
        $env:all_proxy = ''
    }
    elseif ( $(echo $the_port | wc -L) -lt 2 ) {
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
