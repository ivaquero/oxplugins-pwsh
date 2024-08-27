##########################################################
# config
##########################################################

if ([string]::IsNullOrEmpty("$env:JULIA_DEPOT_PATH\environments")) {
    mkdir "$env:JULIA_DEPOT_PATH\environments"
}

if ([string]::IsNullOrEmpty($env:OX_JULIA_ENV_ACTIVE)) {
    $env:OX_JULIA_ENV_ACTIVE = $Global:OX_JULIA_ENV.b
}

# default files
$env:OX_OXYGEN.oxjl = "$env:OXIDIZER\defaults\startup.jl"
# system files
$env:OX_ELEMENT.jl = "$env:JULIA_DEPOT_PATH\config\startup.jl"
# backup files
$env:OX_OXIDE.bkjl = "$env:OX_BACKUP\julia\startup.jl"

function up_julia {
   param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_file = "$Global:OX_OXIDE.bkjlb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_file = "$Global:OX_OXIDE.bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_file = $the_file
    }

    echo "Update Julia Env $julia_env by $julia_backup"
    $pkgs = (cat $($julia_backup) | tr '\n' ', ' | sed 's/$/"/g' | sed 's/^/"/g' | sed 's/,/", "/g' | sed 's/, ""//g')
    $cmd = (echo "using Pkg; Pkg.activate(";;"); Pkg.add([,,])" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "'$cmd'"
}

function back_julia {
   param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_file = "$Global:OX_OXIDE.bkjlb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_file = "$Global:OX_OXIDE.bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_file = $the_file
    }

    echo "Backup Julia Env $julia_env to $julia_file"
    cat $env:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o "\w.*=" | tr -d '= ' > $julia_file
}

function clean_conda {
   param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_file = "$Global:OX_OXIDE.bkjlb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_file = "$Global:OX_OXIDE.bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_file = $the_file
    }

    echo "Cleanup Julia Env $julia_env by $julia_file"
    $the_leaves = (jllv $julia_env)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $julia_file | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            echo "Removing $line"
            jlus $line
        }
    }
    if ($(echo $the_leaves | wc -w) -eq $(cat $julia_file | wc -w) -and ($(echo $the_leaves | wc -c)) -eq $(cat $julia_file | wc -c)) {
        echo "Julia Env Cleanup Finished"
    }
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
    julia --eval 'using Pkg; Pkg.activate(";;"); Pkg.gc()'
}
function jlst {
    julia --eval 'using Pkg; Pkg.activate(";;"); Pkg.status()'
}

function jleat {
    $env:OX_JULIA_ENV_ACTIVE = $Global:OX_JULIA_ENV.$args[1]
    echo "Activate Julia Env $env:OX_JULIA_ENV_ACTIVE"
}

# install packages
function jlis {
    $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
    # echo $pkgs
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.add([,,])' | sd ",," "$pkgs" | sd ";;" "$env:OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# uninstall packages
function jlus {
    $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.rm([,,])' | sd ",," "$pkgs" | sd ";;" "$env:$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# update packages
function jlup {
    if ([string]::IsNullOrEmpty($args)) {
        julia --eval 'using Pkg; Pkg.activate(";;"); Pkg.update() | sd ";;" "$env:$OX_JULIA_ENV_ACTIVE"'
    }
    else {
        $pkgs = $(echo "'$args'" | sed 's/ /\", \"/g')
        $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.update([,,])' | sd ";;" "$env:$OX_JULIA_ENV_ACTIVE")
        echo "'$cmd'"
        julia --eval "'$cmd'"
    }
}

# list leave packages
function jllv {
    cat $env:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o '\w+ =' | tr " =" " "
}

# list packages
function jlls {
    cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg -o 'deps\.\w+' | tr -d "deps\."
}

# dependencies of package
function jldp {
    $cmd = $(echo 'using Pkg; Pkg.activate(";;"); using PkgDependency; PkgDependency.tree(",,") |> println' | sd ",," "$args[1]" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jldpr {
    $cmd = $(echo 'using Pkg; Pkg.activate(";;"); using PkgDependency; PkgDependency.tree(",,"; reverse=true) |> println' | sd ",," "$args[1]" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jlpn {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.pin([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

function jlpnr {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.free([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# calculate mature rate
function jlmt {
    $num_total = (cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg "version =" | wc -l)
    echo "total: $num_total"
    $num_immature = (cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg '\"0\.' | wc -l)
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
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.build([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}

# test project
function jlts {
    local pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    $cmd = (echo 'using Pkg; Pkg.activate(";;"); Pkg.test([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "'$cmd'"
    julia --eval "'$cmd'"
}
