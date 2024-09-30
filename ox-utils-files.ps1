##########################################################
# Configuration File Utils
##########################################################

Remove-Item alias:cp -Force -ErrorAction SilentlyContinue
Remove-Item alias:curl -Force -ErrorAction SilentlyContinue
Remove-Item alias:dir -Force -ErrorAction SilentlyContinue
Remove-Item alias:echo -Force -ErrorAction SilentlyContinue
Remove-Item alias:kill -Force -ErrorAction SilentlyContinue
Remove-Item alias:mv -Force -ErrorAction SilentlyContinue
Remove-Item alias:rm -Force -ErrorAction SilentlyContinue
Remove-Item alias:rmdir -Force -ErrorAction SilentlyContinue
Remove-Item alias:sleep -Force -ErrorAction SilentlyContinue
Remove-Item alias:tee -Force -ErrorAction SilentlyContinue

function test_oxpath {
    if ([string]::IsNullOrEmpty($args[0])) {
        echo "$args[0] does not exist, please define it in custom.ps1"
    }
    if (!(Test-Path -Path $(dirname $args[0]))) {
        mkdir $(dirname $args[0])
    }
}

# oxidize file: backup configuration file
function oxf {
    $files = $args

    ForEach ( $file in $files ) {
        $bkfile = "bk" + $file
        $in_path = $Global:OX_ELEMENT."$file"
        $out_path = $Global:OX_OXIDE.$bkfile

        test_oxpath $out_path

        if ( $file.EndsWith("_") ) {
            rm -rf $out_path
            cp -R $in_path $out_path
        }
        else {
            cp $in_path $out_path
        }
    }
}

# reduce file: owerwrite configuation file by backup file
function rdf {
    $files = $args

    ForEach ( $file in $files ) {
        $bkfile = "bk" + $file
        $in_path = $Global:OX_OXIDE.$bkfile
        $out_path = $Global:OX_ELEMENT."$file"

        test_oxpath $out_path

        if ( $file.EndsWith("_") ) {
            rm -rf $out_path
            cp -R $in_path $out_path
        }
        else {
            cp $in_path $out_path
        }

    }
}

# catalyze file: owerwrite configuartion file by Oxidizer defaults
function clzf {
    $files = $args
    ForEach ( $file in $files ) {
        $oxfile = "ox" + $file
        $in_path = $Global:OX_OXYGEN.$oxfile
        $out_path = $Global:OX_ELEMENT."$file"

        test_oxpath $out_path
        cp $in_path $out_path
    }
}

# propagate file: backup Oxidizer defaults
function ppgf {
    $files = $args
    ForEach ( $file in $files ) {
        $oxfile = "ox" + $file
        $bkfile = "bk" + $file
        $in_path = $Global:OX_OXYGEN.$oxfile
        $out_path = $Global:OX_OXIDE.$bkfile

        test_oxpath $out_path
        cp $in_path $out_path
    }
}

function epf { oxf $args }
function ipf { rdf $args }
function iif { clzf $args }

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
function zpfr { ouch decompress $args }
function zpls { ouch list $args }

##########################################################
# Hash Files
##########################################################

function md5 { hashsum --md5 $args }
function sha1 { hashsum --sha1 $args }
function sha2 { hashsum --sha256 $args }
function sha5 { hashsum --sha512 $args }

##########################################################
# Editor
##########################################################

function ched {
    param ( $editor )
    sed -i.bak "s|EDITOR = .*|EDITOR = \'$editor\|" $Global:OX_ELEMENT.ox
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
