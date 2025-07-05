##########################################################
# Configuration File Utils
##########################################################

Remove-Item alias:cp -Force -ErrorAction SilentlyContinue
Remove-Item alias:curl -Force -ErrorAction SilentlyContinue
Remove-Item alias:dir -Force -ErrorAction SilentlyContinue
Remove-Item alias:Write-Output -Force -ErrorAction SilentlyContinue
Remove-Item alias:kill -Force -ErrorAction SilentlyContinue
Remove-Item alias:mv -Force -ErrorAction SilentlyContinue
Remove-Item alias:rm -Force -ErrorAction SilentlyContinue
Remove-Item alias:rmdir -Force -ErrorAction SilentlyContinue
Remove-Item alias:sleep -Force -ErrorAction SilentlyContinue
Remove-Item alias:tee -Force -ErrorAction SilentlyContinue

function test_oxpath {
    if ([string]::IsNullOrEmpty($args[0])) {
        Write-Output "$args[0] does not exist, please define it in custom.json"
    }
    if (!(Test-Path -Path $(dirname $args[0]))) {
        mkdir $(dirname $args[0])
    }
}

# oxidize file: backup configuration file
function oxf {
    $files = $args

    foreach ( $file in $files ) {
        $bkfile = 'bk' + $file
        $in_path = $Global:OX_ELEMENT."$file"
        $out_path = "$Global:OX_BACKUP" + '/' + $Global:OX_OXIDE.$bkfile

        Write-Output "Backup $in_path to $out_path"
        test_oxpath $out_path
        if ( $file.EndsWith('_') ) {
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

    foreach ( $file in $files ) {
        $bkfile = 'bk' + $file
        $in_path = "$Global:OX_BACKUP" + '/' + $Global:OX_OXIDE.$bkfile
        $out_path = $Global:OX_ELEMENT."$file"

        Write-Output "Overwrite $in_path to $out_path"
        test_oxpath $out_path
        if ( $file.EndsWith('_') ) {
            rm -rf $out_path
            cp -R $in_path $out_path
        }
        else {
            cp $in_path $out_path
        }
    }
}

# catalyze file: owerwrite configuartion file by oxidizer defaults
function clzf {
    $files = $args
    foreach ( $file in $files ) {
        $oxfile = 'ox' + $file
        $in_path = "$env:OXIDIZER" + '/' + $Global:OX_OXYGEN.$oxfile
        $out_path = $Global:OX_ELEMENT."$file"

        Write-Output "Overwrite $in_path to $out_path"
        test_oxpath $out_path
        cp $in_path $out_path
    }
}

# propagate file: backup oxidizer defaults
function ppgf {
    $files = $args
    foreach ( $file in $files ) {
        $oxfile = 'ox' + $file
        $bkfile = 'bk' + $file
        $in_path = "$env:OXIDIZER" + '/' + $Global:OX_OXYGEN.$oxfile
        $out_path = "$Global:OX_BACKUP" + '/' + $Global:OX_OXIDE.$bkfile

        Write-Output "Backup $in_path to $out_path"
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
    if ( $file.EndsWith('_')  ) {
        $cmd = 'ls'
    }
    else {
        $cmd = 'cat'
    }
    switch ( $file ) {
        { $file -match 'ox\w{1,}' } { . $cmd $Global:OX_OXYGEN."$file" }
        { $file -match 'bk\w{1,}' } { . $cmd $Global:OX_OXIDE."$file" }
        default { . $cmd $Global:OX_ELEMENT."$file" }
    }
}

# edit file by default editor
function edf {
    param ( $file, $mode )
    if ( $mode -eq '-t' ) { $cmd = $env:EDITOR_T }
    else { $cmd = $env:EDITOR }

    switch ( $file ) {
        { $file -match 'ox[a-z]{1,}' } { . $cmd $Global:OX_OXYGEN."$file" }
        { $file -match 'bk[a-z]{1,}' } { . $cmd $Global:OX_OXIDE."$file" }
        default { . $cmd $Global:OX_ELEMENT."$file" }
    }
}

##########################################################
# Zip Files
##########################################################

function zpf { ouch compress $args }
function zpfr { ouch decompress $args }
function zpfls { ouch list $args }

##########################################################
# Hash Files
##########################################################

function md5 { md5sum.exe --md5 $args }
function sha1 { sha1sum.exe --sha1 $args }
function sha2 { sha256sum.exe --sha256 $args }
function sha5 { sha512sum.exe --sha512 $args }
