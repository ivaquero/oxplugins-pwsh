##########################################################
# main
##########################################################

function pdls {
    Write-Output 'input-formats`n'
    pandoc --list-input-formats
    Write-Output 'output-formats`n'
    pandoc --list-output-formats
}

if ([string]::IsNullOrEmpty($env:OX_FONT)) {
    $env:OX_FONT = "Arial Unicode MS"
}
function font { param ( $the_font ) $env:OX_FONT = $the_font }

##########################################################
# text
##########################################################

function tohtml {
    param ( $file )
    $name = (basename $file)
    pandoc $file -o $name.html --standalone --mathjax --shift-heading-level-by=-1
}

function tomd {
    pandoc $file -o $name.md
}

function todocx {
    pandoc $file -o $name.docx
}

function totyp {
    pandoc $file -o $name.typ
}

##########################################################
# media
##########################################################

function tomp3 {
    param ( $file, $bitrate )
    $name = (basename $file)
    if ([string]::IsNullOrEmpty($cbr)) { $bitrate = "192K" }
    else { $cbr = $bitrate + "K" }

    ffmpeg -i $file -c:a libmp3lame -b:a $cbr $name.mp3
}

function tomp4 {
    param ( $file )
    $name = (basename $file)
    ffmpeg -fflags +genpts -i $file -r 24 $name .mp4
}

##########################################################
# python
##########################################################

function py2html {
    param ( $file )
    $name = (basename $file)
    marimo export html $name.py > $name.html
}

function ipynb2py {
    param ( $file )
    $name = (basename $file)
    marimo convert $name.ipynb > $name.py
}
