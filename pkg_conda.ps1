##########################################################
# config
##########################################################

# system files
$env:OX_ELEMENT.c = "$HOME\.condarc"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\conda")) {
    mkdir "$env:OX_BACKUP\conda"
}

if (Get-Command mamba -ErrorAction SilentlyContinue ) {
    $env:OX_CONDA = "mamba"
    $env:OX_CONDA2 = "conda"
}
elseif (Get-Command micromamba -ErrorAction SilentlyContinue ) {
    $env:OX_CONDA = "micromamba"
    $env:OX_CONDA2 = "micromamba"
}
elseif (Get-Command conda -ErrorAction SilentlyContinue ) {
    $env:OX_CONDA = "conda"
    $env:OX_CONDA2 = "conda"
}
else {
    Write-Output "No conda package manager found"
}

$custom = Get-Content -Path "$env:OXIDIZER/custom.json" | ConvertFrom-Json
$env:OX_CONDA_ENV = $custom.conda_env_shortcuts

function up_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].Length -lt 2 ) {
        $conda_env = $env:OX_CONDA_ENV."$args"
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    Write-Output "Update Conda Env $conda_env by $conda_file"
    $pkg = (cat $conda_file | tr '\n' '')
    Write-Output "$env:OX_CONDA install $pkg"
    . $env:OX_CONDA install $pkgs
}

function back_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].Length -lt 2 ) {
        $conda_env = $env:OX_CONDA_ENV."$args"
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    Write-Output "Backup Conda Env $conda_env to $conda_file"
    conda tree -n $conda_env leaves | sort > "$conda_file"
}

function clean_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].Length -lt 2 ) {
        $conda_env = $env:OX_CONDA_ENV."$args"
        $conda_file = $env:OX_BACKUP + "/" + $env:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    Write-Output "Cleanup Conda Env $conda_env by $conda_file"
    $the_leaves = (conda tree -n $conda_env leaves)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $conda_file | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            Write-Output "Removing $line"
            . $env:OX_CONDA remove -n $conda_env $line --quiet --yes
        }
    }
    if ($(Write-Output $the_leaves | wc -w) -eq $(cat $conda_file | wc -w) -and ($(Write-Output $the_leaves | wc -c)) -eq $(cat $conda_file | wc -c)) {
        Write-Output "Conda Env Cleanup Finished"
    }
}

##########################################################
# packages
##########################################################

function ch { . $env:OX_CONDA --help $args }
function ccf { . $env:OX_CONDA config $args }
function cis { . $env:OX_CONDA install $args }
function cus { . $env:OX_CONDA remove $args }

# clean packages
function ccl {
    param ( $cmd )
    Switch ( $cmd ) {
        -l { . $env:OX_CONDA clean --logfiles }
        -i { . $env:OX_CONDA clean --index-cache }
        -p { . $env:OX_CONDA clean --packages }
        -t { . $env:OX_CONDA clean --tarballs }
        -f { . $env:OX_CONDA clean --force-pkgs-dirs }
        -a { . $env:OX_CONDA clean --all }
        Default {
            . $env:OX_CONDA clean --packages
            . $env:OX_CONDA clean --tarballs
        }
    }
}

# update packages
function cup {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { . $env:OX_CONDA update --all }
    elseif ( $the_env.Length -lt 2 ) {
        . $env:OX_CONDA update --all -n $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else { . $env:OX_CONDA update --all -n $the_env }
}

##########################################################
# info
##########################################################

function cif { . $env:OX_CONDA info }
function csc { . $env:OX_CONDA search $args }

Remove-Item alias:cls -Force -ErrorAction SilentlyContinue
Remove-Item alias:clv -Force -ErrorAction SilentlyContinue
# list packages
# $1=name
function cls {
    param ( $the_env )
    if ( $the_env.Length -eq 0 ) { . $env:OX_CONDA list }
    elseif ( $the_env.Length -lt 2 ) {
        . $env:OX_CONDA list -n $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else { . $env:OX_CONDA list -n $the_env }
}

# list leave packages
# $1=name
function clv {
    param ( $the_env )
    if ( $the_env.Length -eq 0) { conda-tree leaves | sort }
    elseif ( $the_env.Length -lt 2 ) {
        conda-tree -n $(Write-Output $env:OX_CONDA_ENV.$the_env) leaves | sort
    }
    else { conda-tree -n $the_env leaves | sort }
}

function Set-Locationp { . $env:OX_CONDA repoquery depends $args }
# specific
function Set-Locationpr { . $env:OX_CONDA repoquery whoneeds $args }

function cmt {
    param ( $the_env )
    $num_total = (cls $the_env | wc -l)
    Write-Output "total: $num_total"
    $num_immature = (cls $the_env | rg -c "\s0\.\d")
    $ratio = $num_immature / $num_total * 100
    $mature_rate = '{0:N0}' -f $(100 - $ratio)
    Write-Output "mature rate: $mature_rate %"
}

##########################################################
# extension
##########################################################

function cxa { . $env:OX_CONDA config --add channels $args }
function cxrm { . $env:OX_CONDA config --remove channels $args }
function cxls { . $env:OX_CONDA config --get channels }

##########################################################
# project
##########################################################

function cii {
    switch ($env:OX_CONDA) {
        conda { . $env:OX_CONDA init $args }
        Default { . $env:OX_CONDA shell init $args }
    }
}
function cr { . $env:OX_CONDA run $args }

##########################################################
# environments
##########################################################

# check environment health
function cck {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { conda doctor }
    elseif ( $the_env.Length -lt 2 ) {
        conda doctor -n $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else { conda doctor -n $the_env }
}

# activate environment: $1=name
function ceat {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) {
        . $env:OX_CONDA2 activate base; clear
    }
    elseif ( $the_env.Length -lt 2 ) {
        . $env:OX_CONDA2 activate $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else {
        . $env:OX_CONDA2 activate $the_env
    }
}

function ceq { . $env:OX_CONDA2 deactivate; clear }
function cels { . $env:OX_CONDA env list }

# reactivate environment: $1=name
function cerat {
    param ( $the_env )
    ceq
    ceat $the_env
}

# create environment: $1=name
function cecr {
    param ( $the_env )
    if ( $the_env.Length -lt 2 ) {
        . $env:OX_CONDA create -n $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else {
        . $env:OX_CONDA create -n $the_env
    }
    ceat $the_env
}

# delete environment: $1=name
function cerm {
    param ( $the_env )
    conda deactivate
    if ( $the_env.Length -lt 2 ) {
        . $env:OX_CONDA env remove -n $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else { . $env:OX_CONDA env remove -n $the_env }
}

# change environment subdir
function cesd {
    param ( $arch )
    Switch ( $arch ) {
        a { . $env:OX_CONDA env config vars set CONDA_SUBDIR=win-arm64 }
        i { . $env:OX_CONDA env config vars set CONDA_SUBDIR=win-64 }
    }
}

# export environment: $1=name
function ceep {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { $conda_env = base }
    elseif ( $the_env.Length -lt 2 ) {
        $conda_env = $(Write-Output $env:OX_CONDA_ENV.$the_env)
    }
    else { $conda_env = $the_env }
    . $env:OX_CONDA env export -n $conda_env -f $env:OX_BACKUP\conda\$conda_env-win.yml
}

# rename environment
function cern {
    param ( $old, $new )
    if ( $old.Contains('\') ) { . $env:OX_CONDA rename --prefix $old $new }
    else { . $env:OX_CONDA rename --name $old $new }
}

function cedf { conda compare $args }
