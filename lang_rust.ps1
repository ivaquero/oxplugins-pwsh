##########################################################
# config
##########################################################

# system files
$Global:OX_ELEMENT.cg = "$HOME\.cargo\config.toml"
$Global:OX_ELEMENT.rs = "$HOME\.rustup\settings.toml"
# backup files
if ([string]::IsNullOrEmpty("$Global:OX_BACKUP\rust")) {
    mkdir "$Global:OX_BACKUP\rust"
}

##########################################################
# packages
##########################################################

function cgh { cargo help $args }
function cgis { cargo install $args }
function cgus { cargo uninstall $args }
function cgup { cargo update $args }
function cgls { cargo install --list }
function cgcl { cargo clean }
function cgsc { cargo search $args }
function cgck { cargo check }
function cgdp { cargo tree $args }
function cgcf { cargo config $args }

function cgif {
    cargo $($pkg + ' info')
}

##########################################################
# project
##########################################################

function cgb { cargo build $args }
function cgr { cargo run $args }
function cgts { cargo test $args }
function cgfx { cargo fix $args }
function cgpb { cargo publish $args }
function cgii { cargo init $args }
function cgcr { cargo create $args }

##########################################################
# rustup
##########################################################

function rsh { rustup help $args }
function rsis { rustup component add $args }
function rsus { rustup component remove $args }
function rsls { rustup component list }
function rsup { rustup update }
function rsck { rustup check }
function rsr { rustup run }
