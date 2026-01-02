##########################################################
# main
##########################################################

function pdlsi {
    Write-Output "input-formats`n"
    pandoc --list-input-formats
}

function pdlso {
    Write-Output "output-formats`n"
    pandoc --list-output-formats
}

function pdref {
    pandoc --print-default-data-file reference.docx >custom-reference.docx
}

##########################################################
# text
##########################################################

function tohtml {
    param ($file)
    $name = (Get-Item $file).Basename
    pandoc $file -o $name.html --to html5 --standalone --mathjax --shift-heading-level-by=-1
}

function tomd {
    param ($file)
    $name = (Get-Item $file).Basename
    $ext = (Get-Item $file).Extension
    if ( $ext -eq '.ipynb') {
        jupytext --to md $file
    }
    else {
        pandoc $file -o $name.md
    }
}

function totyp {
    param ($file)
    $name = (Get-Item $file).Basename
    pandoc $file -o $name.typ
}

function todocx {
    param ($file)
    $name = (Get-Item $file).Basename
    pandoc $file -o $name.docx
}

function topdf {
    param ($file)
    $name = (Get-Item $file).Basename
    if (Get-Command tectonic -ErrorAction SilentlyContinue ) {
        $Global:OX_PDF_ENGINE = tectonic
    }
    elseif (Get-Command xelatex -ErrorAction SilentlyContinue ) {
        $Global:OX_PDF_ENGINE = xelatex
    }
    elseif (Get-Command lualatex -ErrorAction SilentlyContinue ) {
        $Global:OX_PDF_ENGINE = lualatex
    }
    elseif (Get-Command pdflatex -ErrorAction SilentlyContinue ) {
        $Global:OX_PDF_ENGINE = pdflatex
    }
    else {
        Write-Output 'No available pdf engine found'
    }
    pandoc $file -o $name.pdf --pdf-engine=$Global:OX_PDF_ENGINE --syntax-highlighting tango \
    -V colorlinks \
    -V urlcolor=NavyBlue \
    -V geometry:a4paper \
    -V geometry:margin=2.5cm \
    -V CJKmainfont="STFangsong"
}

function toipynb {
    param ($file)
    jupytext --to notebook $file
}

##########################################################
# notebook
##########################################################

function py2html {
    param ($file)
    $name = (Get-Item $file).Basename
    marimo export html $file > $name.html
}

function ipynb2py {
    param ($file)
    $name = (Get-Item $file).Basename
    marimo convert $file > $name.py
}

##########################################################
# image
##########################################################

function topng {
    param ($file)
    $name = (Get-Item $file).Basename
    magick $file -o $name.png
}

function tojpg {
    param ($file)
    $name = (Get-Item $file).Basename
    magick $file -o $name.jpg
}

function bgnone {
    param ( $file, $color )
    if ([string]::IsNullOrEmpty($color)) { $bg = 'white' }
    else { $bg = $color }
    magick $file -background $bg $file
}

##########################################################
# media
##########################################################

function tomp3 {
    param ( $file, $bitrate )
    $name = (Get-Item $file).Basename
    if ([string]::IsNullOrEmpty($cbr)) { $bitrate = '192K' }
    else { $cbr = $bitrate + 'K' }

    ffmpeg -i $file -c:a libmp3lame -b:a $cbr $name.mp3
}

function tomp4 {
    param ($file)
    $name = (Get-Item $file).Basename
    ffmpeg -fflags +genpts -i $file -r 24 $name .mp4
}
