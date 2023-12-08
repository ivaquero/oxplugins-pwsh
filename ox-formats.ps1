##########################################################
# text
##########################################################

function pdls {
    echo 'input-formats`n'
    pandoc --list-input-formats
    echo 'output-formats`n'
    pandoc --list-output-formats
}

if ([string]::IsNullOrEmpty($env:OX_FONT)) {
    $env:OX_FONT = "Arial Unicode MS"
}
function font { param ( $the_font ) $env:OX_FONT = $the_font }

##########################################################
# markdown
##########################################################

function mdto {
    param ( $format, $file )
    $name = (basename $file)
    if ( $format -eq 'pdf' ) {
        if (Get-Command tectonic -ErrorAction SilentlyContinue) {
            $pdf_engine = tectonic
        }
        elseif (Get-Command xelatex -ErrorAction SilentlyContinue) {
            $pdf_engine = xelatex
        }
        else {
            echo 'No available pdf engine found'
        }
        pandoc $file -o ($name + "." + $format) --pdf-engine=$pdf_engine -V CJKmainfont=$env:OX_FONT
    }
    elif ( $format -eq 'html') {
        pandoc $file -o ($name + "." + $format) --standalone --mathjax --shift-heading-level-by=-1
    }
    else {
        pandoc $file -o ($name + "." + $format)
    }
 }

##########################################################
# audio
##########################################################

function tomp3 {
    param ( $file, $bitrate )
    $name = (basename $file)
    if ([string]::IsNullOrEmpty($cbr)) { $bitrate = "192K" }
    else { $cbr = $bitrate + "K" }

    ffmpeg -i $file -c:a libmp3lame -b:a $cbr $name.mp3
}
