##########################################################
# config
##########################################################

if ([string]::IsNullOrEmpty("$env:JULIA_DEPOT_PATH\environments")) {
    mkdir "$env:JULIA_DEPOT_PATH\environments"
}
# system files
$env:OX_ELEMENT.jl = "$env:JULIA_DEPOT_PATH\config\startup.jl"

$env:OX_JULIA_ENV_BASE = "$env:JULIA_DEPOT_PATH/environments/v$(julia -v | rg -o "\d+\.\d+")"
if ($env:OS) {
    $env:OX_JULIA_ENV = $env:OX_CUSTOM.julia_env_shortcuts_win
}
else {
    $env:OX_JULIA_ENV = $env:OX_CUSTOM.julia_env_shortcuts
}
$Global:bkjlb = $env:OX_OXIDE.jlb

if ([string]::IsNullOrEmpty($env:OX_JULIA_ENV_ACTIVE)) {
    $env:OX_JULIA_ENV_ACTIVE = $env:OX_JULIA_ENV_BASE
}

function up_julia {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $julia_env = $env:OX_JULIA_ENV_BASE
        $julia_backup = $Global:bkjlb
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $julia_env = $env:OX_JULIA_ENV.$args[0]
        $julia_backup = $env:OX_BACKUP + "/" + $env:OX_OXIDE.(bkjl+$args[0])
    }
    else {
        $julia_env = $args[0]
        $julia_backup = $args[1]
    }

    Write-Output "Update Julia Env $julia_env by $julia_backup"
    $pkgs = (cat $($julia_backup) | tr '\n' ', ' | sd '^' '"' | sd ', $' '"' | sd ',' '", "')
    jleat $julia_env
    $cmd = (Write-Output 'using Pkg; Pkg.add([,,])' | sd ",," "$pkgs")
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

function back_julia {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $julia_backup = $Global:bkjlb
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $julia_backup = $env:OX_BACKUP + "/" + $env:OX_OXIDE.(bkjl+$args[0])
    }
    else {
        $julia_backup = $args[1]
    }

    Write-Output "Backup Julia Env $julia_env to $julia_backup"
    cat $env:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o "\w.*=" | tr -d '= ' > $julia_backup
}

function clean_julia {
    if ([string]::IsNullOrEmpty( $args[0] )) {
        $julia_env = $env:OX_JULIA_ENV_BASE
        $julia_backup = $Global:bkjlb
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $julia_env = $env:OX_JULIA_ENV.$args[0]
        $julia_backup = $env:OX_BACKUP + "/" + $env:OX_OXIDE.(bkjl+$args[0])
    }
    else {
        $julia_env = $args[0]
        $julia_backup = $args[1]
    }

    Write-Output "Cleanup Julia Env $julia_env by $julia_backup"
    $the_leaves = (jllv $julia_env)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $julia_backup | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            Write-Output "Removing $line"
            jlus $line
        }
    }
    if ((Write-Output $the_leaves | wc -w) -eq $(cat $julia_backup | wc -w) -and ((Write-Output $the_leaves | wc -c)) -eq $(cat $julia_backup | wc -c)) {
        Write-Output "Julia Env Cleanup Finished"
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
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval $args
}

function jleat {
    param ( $julia_env )
    $env:OX_JULIA_ENV_ACTIVE = $env:OX_JULIA_ENV.$julia_env
    Write-Output "Activate Julia Env $env:OX_JULIA_ENV_ACTIVE"
}

function jldf {
    param ( $julia_env )
    $the_env = $env:OX_JULIA_ENV.$julia_env
    $env:OX_JULIA_ENV_ACTIVE = $the_env
    Set-Location $env:OX_JULIA_ENV_ACTIVE
    git diff Manifest.toml
    lines = $(cat Manifest.toml | wc -l)
    Write-Output " total lines: $lines"
    z -
}

function jlcl {
    julia --project="$env:OX_JULIA_ENV_ACTIVE"  --eval 'using Pkg; Pkg.gc()'
}
function jlst {
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval 'using Pkg; Pkg.status()'
}

# install packages
function jlis {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.add([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# uninstall packages
function jlus {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.rm([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# update packages
function jlup {
    if (-not $args) {
        $cmd = 'using Pkg; Pkg.update()'
    }
    else {
        $pkgs = ($args -join '\", \"')
        $cmd = 'using Pkg; Pkg.update([\"' + $pkgs + '\"])'
    }
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# list leave packages
function jllv {
    cat $env:OX_JULIA_ENV_ACTIVE/Project.toml | rg -o '\w+ =' | tr " = " " "
}

# list packages
function jlls {
    cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg -o 'deps\.\w+' | tr -d "deps\."
}

# dependencies of package
function jldp {
    param ( $julia_pkg )
    $cmd = 'using Pkg; using PkgDependency; PkgDependency.tree(\"' + $julia_pkg + '\") |> println'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

function jldpr {
    param ( $julia_pkg )
    $cmd = 'using Pkg; using PkgDependency; PkgDependency.tree(\"' + $julia_pkg + '\"; reverse=true) |> println'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

function jlpn {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.pin([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

function jlpnr {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.free([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# calculate mature rate
function jlmt {
    $num_total = (cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg "version =" | wc -l)
    Write-Output "total: $num_total"
    $num_immature = (cat $env:OX_JULIA_ENV_ACTIVE/Manifest.toml | rg '\"0\.' | wc -l)
    $ratio = $num_immature / $num_total * 100 -as [float]
    $mature_rate = ($(100 - $ratio) -as [float])
    Write-Output "mature rate: $mature_rate %"
}

##########################################################
# packages
##########################################################

# build project
function jlb {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.build([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# test project
function jlts {
    $pkgs = ($args -join '\", \"')
    $cmd = 'using Pkg; Pkg.test([\"' + $pkgs + '\"])'
    Write-Output "$cmd"
    julia --project="$env:OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}
