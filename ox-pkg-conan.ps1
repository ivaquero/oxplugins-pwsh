##########################################################
# config
##########################################################

# system files
$Global:OX_ELEMENT.cn = "$HOME\.conan\conan.conf"
$Global:OX_ELEMENT.cnr = "$HOME\.conan\remotes.json"
$Global:OX_ELEMENT.cnd = "$HOME\.conan\profiles\default"

# back files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\conan")) {
    mkdir "$env:OX_BACKUP\conan"
}
$Global:OX_OXIDE.bkcn = "$env:OX_BACKUP\conan\conan.conf"
$Global:OX_OXIDE.bkcnr = "$env:OX_BACKUP\conan\remotes.json"
$Global:OX_OXIDE.bkcnd = "$env:OX_BACKUP\conan\profiles\default"

##########################################################
# packages
##########################################################

function cnh { conan help $args }
function cnis { conan install $args }
function cnus { conan remove $args }


function cnsc {
    Switch ( $args[0] ) {
        -m { conan search --remote=conancenter $args[1] }
        Default { conan search $args[0] }
    }
}
function cndl {
    Switch ( $args[0] ) {
        -m { conan download --remote=conancenter $args[1] }
        Default { conan download $args[0] }
    }
}

function cndp { conan graph }
function cncf { conan config }

##########################################################
# extension
##########################################################

function cnxa { conan remote add $args }
function cnxrm { conan remote remove $args }
function cnxls { conan remote list }

##########################################################
# project
##########################################################

function cncr { conan create $args }
function cnb { conan build $args }
function cnif { conan inspect $args }
function cnpb { conan publish $args }
function cnts { conan test $args }
