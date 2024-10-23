##########################################################
# config
##########################################################

if ([string]::IsNullOrEmpty("$env:JULIA_DEPOT_PATH\environments")) {
    mkdir "$env:JULIA_DEPOT_PATH\environments"
}

if ([string]::IsNullOrEmpty($Global:OX_JULIA_ENV_ACTIVE)) {
    $Global:OX_JULIA_ENV_ACTIVE = $Global:OX_JULIA_ENV.b
}

# system files
$Global:OX_ELEMENT.jl = "$env:JULIA_DEPOT_PATH\config\startup.jl"
# backup files
$Global:OX_OXIDE.bkjl = "$env:OX_BACKUP\julia\startup.jl"

function up_julia {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_backup = $Global:OX_OXIDE.bkjlb
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_backup = $Global:OX_OXIDE."bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_backup = $the_file
    }

    echo "Update Julia Env $julia_env by $julia_backup"
    $pkgs = (cat $($julia_backup) | tr '\n' ', ' | sd '^' '"' | sd ',$' '"' | sd ',' '","')
    $julia_env = ($julia_env | sd "\\" "/")
    $cmd = (echo 'using Pkg; Pkg.activate("$julia_env"); Pkg.add([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

function back_julia {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_backup = $Global:OX_OXIDE.bkjlb
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_backup = $Global:OX_OXIDE."bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_backup = $the_file
    }

    echo "Backup Julia Env $julia_env to $julia_backup"
    cat $Global:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o "\w.*=" | tr -d '= ' > $julia_backup
}

function clean_conda {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $julia_env = $Global:OX_julia_ENV.b
        $julia_backup = $Global:OX_OXIDE.bkjlb
    }
    elseif ( $(echo $the_env | wc -L) -lt 3 ) {
        $julia_env = $Global:OX_julia_ENV.$the_env
        $julia_backup = $Global:OX_OXIDE."bkjl$the_env"
    }
    else {
        $julia_env = $the_env
        $julia_backup = $the_file
    }

    echo "Cleanup Julia Env $julia_env by $julia_backup"
    $the_leaves = (jllv $julia_env)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $julia_backup | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            echo "Removing $line"
            jlus $line
        }
    }
    if ($(echo $the_leaves | wc -w) -eq $(cat $julia_backup | wc -w) -and ($(echo $the_leaves | wc -c)) -eq $(cat $julia_backup | wc -c)) {
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
    if (-not $args) { $julia_env = 'b' }
    else { $julia_env = $args[0] }
    $julia_env = ($Global:OX_JULIA_ENV.$julia_env | sd "\\" "/")
    echo "Activate Julia Env $julia_env"
}

# install packages
function jlis {
    jleat $args[0]
    $pkgs = $(echo $args | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.add([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# uninstall packages
function jlus {
    jleat $args[0]
    $pkgs = $(echo $args | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.rm([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# update packages
function jlup {
    jleat $args[0]
    if (-not $args) {
        $cmd = (echo 'using Pkg; Pkg.update()')
    }
    else {
        $pkgs = $(echo "'$args'" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
        $cmd = (echo 'using Pkg; Pkg.update([,,])' | sd ", , " "$pkgs" )
    }
    echo "$cmd"
    julia --eval "$cmd"
}

# list leave packages
function jllv {
    cat $Global:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o '\w+ =' | tr " = " " "
}

# list packages
function jlls {
    cat $Global:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg -o 'deps\.\w+' | tr -d "deps\."
}

# dependencies of package
function jldp {
    param ( $julia_pkg )
    jleat $args[0]
    $cmd = $(echo 'using Pkg; using PkgDependency; PkgDependency.tree(",,") |> println' | sd ",," "$julia_pkg")
    echo "$cmd"
    julia --eval "$cmd"
}

function jldpr {
    jleat $args[0]
    $cmd = $(echo 'using Pkg; using PkgDependency; PkgDependency.tree(",,"; reverse=true) |> println' | sd ",," "$julia_pkg")
    echo "$cmd"
    julia --eval "$cmd"
}

function jlpn {
    jleat $args[0]
    $pkgs = $(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.pin([, , ])' | sd ", , " "$pkgs" )
    echo "$cmd"
    julia --eval "$cmd"
}

function jlpnr {
    jleat $args[0]
    $pkgs = $(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.free([, , ])' | sd ", , " "$pkgs" )
    echo "$cmd"
    julia --eval "$cmd"
}

# calculate mature rate
function jlmt {
    $num_total = (cat $Global:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg "version =" | wc -l)
    echo "total: $num_total"
    $num_immature = (cat $Global:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg '\"0\.' | wc -l)
    $ratio = $num_immature / $num_total * 100 -as [float]
    $mature_rate = ($(100 - $ratio) -as [float])
    echo "mature rate: $mature_rate %"
}

##########################################################
# packages
##########################################################

# build project
function jlb {
    jleat $args[0]
    $pkgs = $(echo "'$args'" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.build([, , ])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# test project
function jlts {
    jleat $args[0]
    $pkgs = $(echo "'$args'" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    $cmd = (echo 'using Pkg; Pkg.test([, , ])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}
