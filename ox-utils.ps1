##########################################################
# Configuration File Utils
##########################################################

Remove-Item alias:cp -Force -ErrorAction SilentlyContinue
Remove-Item alias:dir -Force -ErrorAction SilentlyContinue
Remove-Item alias:echo -Force -ErrorAction SilentlyContinue
Remove-Item alias:kill -Force -ErrorAction SilentlyContinue
Remove-Item alias:mv -Force -ErrorAction SilentlyContinue
Remove-Item alias:rm -Force -ErrorAction SilentlyContinue
Remove-Item alias:rmdir -Force -ErrorAction SilentlyContinue
Remove-Item alias:sleep -Force -ErrorAction SilentlyContinue
Remove-Item alias:tee -Force -ErrorAction SilentlyContinue

# export file
# $@=names
function epf {
    $files = $args

    ForEach ( $file in $files ) {
        $bkfile = "bk" + $file
        $in_path = $Global:OX_ELEMENT.$file
        $out_path = $Global:OX_OXIDE.$bkfile

        if ([string]::IsNullOrEmpty($out_path)) {
            echo "$out_path does not exist, please define it in custom.ps1"
        }
        elseif ( $file.EndsWith("_") ) {
            rm -rf $out_path
            cp -R -v $in_path $out_path
        }
        else {
            if (!(Test-Path -Path $(dirname $out_path))) {
                mkdir $(dirname $out_path)
            }
            cp -v $Global:OX_ELEMENT.$file $Global:OX_OXIDE.$bkfile
        }
    }
}

# import file: reverse action of `epf`
function ipf {
    $files = $args

    ForEach ( $file in $files ) {
        $bkfile = "bk" + $file
        $in_path = $Global:OX_OXIDE.$bkfile
        $out_path = $Global:OX_ELEMENT.$file

        if ( $file.EndsWith("_") ) {
            rm -rf $out_path
            cp -R -v $in_path $out_path
        }
        else {
            if (!(Test-Path -Path $(dirname $out_path))) {
                mkdir $(dirname $out_path)
            }
            cp -v $in_path $out_path
        }
    }
}

# initialize file
function iif {
    $files = $args
    ForEach ( $file in $files ) {
        $oxfile = "ox" + $file
        $in_path = $Global:OX_OXYGEN.$oxfile
        $out_path = $Global:OX_ELEMENT.$file

        if (!(Test-Path -Path $(dirname $out_path))) {
                mkdir $(dirname $out_path)
            }
        cp -v $in_path $out_path
    }
}

# duplicate file
function dpf {
    $files = $args
    ForEach ( $file in $files ) {
        $oxfile = "ox" + $file
        $bkfile = "bk" + $file
        $in_path = $Global:OX_OXYGEN.$oxfile
        $out_path = $Global:OX_OXIDE.$bkfile

        if (!(Test-Path -Path $(dirname $out_path))) {
                mkdir $(dirname $out_path)
            }
        cp -v $in_path $out_path
    }
}

##########################################################
# Gerneral File Utils
##########################################################

# refresh file
function frf {
    & $profile
}

# browse file
function brf {
    param ( $file )
    if ( $file.EndsWith("_")  ) {
        $cmd = "ls"
    }
    else {
        $cmd = "cat"
    }
    Switch ( $file ) {
        { $file -match "ox\w{1,}" } { . $cmd $Global:OX_OXYGEN.$file }
        { $file -match "bk\w{1,}" } { . $cmd $Global:OX_OXIDE.$file }
        Default { . $cmd $Global:OX_ELEMENT.$file }
    }
}

# edit file by default editor
function edf {
    param ( $file, $mode )
    if ( $mode -eq "-t" ) { $cmd = $env:EDITOR_T }
    else { $cmd = $env:EDITOR }

    Switch ( $file ) {
        { $file -match "ox[a-z]{1,}" } { . $cmd $Global:OX_OXYGEN.$file }
        { $file -match "bk[a-z]{1,}" } { . $cmd $Global:OX_OXIDE.$file }
        Default { . $cmd $Global:OX_ELEMENT.$file }
    }
}

##########################################################
# Zip Files
##########################################################

function zpf { ouch compress $args }
function uzpf { ouch decompress $args }
function lzpf { ouch list $args }

##########################################################
# Hash Files
##########################################################

function sha1 { sha1sum $args }
function sha2 { sha256sum $args }
function sha5 { sha512sum $args }

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

##########################################################
# Editor
##########################################################

function che {
    param ( $editor )
    sd "EDITOR = \'.*\'" "EDITOR = \'$editor\'" $Global:OX_ELEMENT.ox
}

##########################################################
# Zoxide
##########################################################

$_ZO_DATA_DIR = "$env:LOCALAPPDATA\zoxide"

if (!(Test-Path -Path $_ZO_DATA_DIR)) {
    mkdir "$_ZO_DATA_DIR"
}
$Global:OX_ELEMENT.z = "$_ZO_DATA_DIR\db.zo"
# backup files
$Global:OX_OXIDE.bkz = "$env:OX_BACKUP\shell\db.zo"

function zh { zoxide --help }
function zii { zoxide init $args }
function za { zoxide add $args }
function zrm { zoxide remove $args }
function zed { zoxide edit $args }
function zsc { zoxide query $args }

Invoke-Expression (& { $hook = if ($PSVersionTable.PSVersion.Major -ge 6) { 'pwd' } else { 'prompt' } (zoxide init powershell --hook $hook | Out-String) })
