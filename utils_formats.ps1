##########################################################
# main
##########################################################

function pdls {
    Write-Output 'input-formats`n'
    pandoc --list-input-formats
    Write-Output 'output-formats`n'
    pandoc --list-output-formats
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

function todocx {
    param ($file)
    $name = (Get-Item $file).Basename
    pandoc $file -o $name.docx
}

function totyp {
    param ($file)
    $name = (Get-Item $file).Basename
    pandoc $file -o $name.typ
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
        echo 'No available pdf engine found'
    }
    pandoc $file -o $name.pdf --pdf-engine=$Global:OX_PDF_ENGINE \
    -V geometry:a4paper \
    -V geometry:margin=2.5cm \
    -V CJKmainfont="STFangsong"
}

function toipynb {
    param ($file)
    jupytext --to notebook $file
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

##########################################################
# python
##########################################################

function py2html {
    param ($file)
    $name = (Get-Item $file).Basename
    marimo export html $name.py > $name.html
}

function ipynb2py {
    param ($file)
    $name = (Get-Item $file).Basename
    marimo convert $name.ipynb > $name.py
}
