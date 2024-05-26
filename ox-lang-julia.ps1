##########################################################
# config
##########################################################

if ([string]::IsNullOrEmpty($env:JULIA_DEPOT_PATH)) {
    $env:JULIA_DEPOT_PATH = "$HOME\.julia"
}

if ([string]::IsNullOrEmpty("$env:JULIA_DEPOT_PATH\environments")) {
    mkdir "$env:JULIA_DEPOT_PATH\environments"
}

$Global:JULIA_VERSION = "$(julia -v | rg -o '\d+\.\d+')"

# default files
$Global:OX_OXYGEN.oxjl = "$env:OXIDIZER\defaults\startup.jl"
# system files
$Global:OX_ELEMENT.jl = "$env:JULIA_DEPOT_PATH\config\startup.jl"
$Global:OX_ELEMENT.jlp = "$env:JULIA_DEPOT_PATH\environments\v$JULIA_VERSION\Project.toml"
$Global:OX_ELEMENT.jlm = "$env:JULIA_DEPOT_PATH\environments\v$JULIA_VERSION\Manifest.toml"
# backup files
$Global:OX_OXIDE.bkjl = "$env:OX_BACKUP\julia\startup.jl"
$Global:OX_OXIDE.bkjlx = "$env:OX_BACKUP\julia\julia-pkgs.txt"

function up_julia {
    echo "Update Julia by $($Global:OX_OXIDE.bkjlx)"
    $pkgs = (cat $($Global:OX_OXIDE.bkjlx) | tr '\n' ', ' | sed 's/$/"/g' | sed 's/^/"/g' | sed 's/,/", "/g' | sed 's/, ""//g')
    $cmd = (echo "using Pkg; Pkg.add([,,])" | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "'$cmd'"
}

function back_julia {
    echo "Backup Julia to $($Global:OX_OXIDE.bkjlx)"
    cat $Global:OX_ELEMENT.jlp | rg -o "\w.*=" | tr -d '= ' > "$($Global:OX_OXIDE.bkjlx)"
}

##########################################################
# packages
##########################################################

function jl {
    julia --quiet
}
function jlh {
    julia --help
}
function jlr {
    param ( $cmd )
    julia --eval $cmd
}
function jlcl {
    julia --eval 'using Pkg; Pkg.gc()'
}
function jlst {
    julia --eval 'using Pkg; Pkg.status()'
}


# install packages
function jlis {
    $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
    # echo $pkgs
    $cmd = (echo 'using Pkg; Pkg.add([,,])' | sed "s/,,/$pkgs/g")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# uninstall packages
function jlus {
    $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.rm([,,])' | sed "s/,,/$pkgs/g")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# update packages
function jlup {
    if ([string]::IsNullOrEmpty($args)) {
        julia --eval 'using Pkg; Pkg.update()'
    }
    else {
        $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
        $cmd = (echo 'using Pkg; Pkg.update([,,])' | sed "s/,,/$pkgs/g")
        echo "'$cmd'"
        julia --eval "'$cmd'"
    }
}

# list leave packages
function jllv {
    cat $Global:OX_ELEMENT.jlp | rg -o '\w+ =' | tr " =" " "
}

# list packages
function jlls {
    cat $Global:OX_ELEMENT.jlm | rg -o 'deps\.\w+' | tr -d "deps\."
}

# dependencies of package
function jldp {
    $cmd = $(echo "using PkgDependency; PkgDependency.tree(\"$args[1]\") |> println")
    # echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jlrdp {
    $cmd = $(echo "using PkgDependency; PkgDependency.tree(\"$args[1]\"; reverse=true) |> println")
    # echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jlpn {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.pin([,,])' | sed "s/,,/$pkgs/g")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jlupn {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.free([,,])' | sed "s/,,/$pkgs/g")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# calculate mature rate
function jlmt {
    $num_total = (cat $Global:OX_ELEMENT.jlm | rg "version =" | wc -l)
    echo "total: $num_total"
    $num_immature = (cat $Global:OX_ELEMENT.jlm | rg '\"0\.' | wc -l)
    $ratio = $num_immature / $num_total * 100 -as [float]
    $mature_rate = ($(100 - $ratio) -as [float])
    echo "mature rate: $mature_rate %"
}

##########################################################
# packages
##########################################################

# build project
function jlb {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = "using Pkg; Pkg.build([$pkgs_f`"])"
    # echo "'$cmd'"
    julia --eval "'$cmd'"
}

# test project
function jlts {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = "using Pkg; Pkg.test([$pkgs_f`"])"
    # echo "'$cmd'"
    julia --eval "'$cmd'"
}
