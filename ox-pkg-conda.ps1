##########################################################
# config
##########################################################

# default files
$Global:OX_OXYGEN.oxc = "$env:OXIDIZER\defaults\.condarc"
# system files
$Global:OX_ELEMENT.c = "$HOME\.condarc"
# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP\conda")) {
    mkdir "$env:OX_BACKUP\conda"
}
$Global:OX_OXIDE.bkc = "$env:OX_BACKUP\conda\.condarc"

if (Get-Command mamba -ErrorAction SilentlyContinue ) {
    $Global:OX_CONDA = "mamba"
    $Global:OX_CONDA2 = "conda"
}
elseif (Get-Command micromamba -ErrorAction SilentlyContinue ) {
    $Global:OX_CONDA = "micromamba"
    $Global:OX_CONDA2 = "micromamba"
}
elseif (Get-Command conda -ErrorAction SilentlyContinue ) {
    $Global:OX_CONDA = "conda"
    $Global:OX_CONDA2 = "conda"
}
else {
    echo "No conda package manager found"
}

function up_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $Global:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $conda_env = (echo $Global:OX_CONDA_ENV."$args")
        $conda_file = $Global:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    echo "Update Conda Env $conda_env by $conda_file"
    $pkg = (cat $conda_file | tr '\n' '')
    echo "$Global:OX_CONDA install $pkg"
    . $Global:OX_CONDA install $pkgs
}

function back_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $Global:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $conda_env = (echo $Global:OX_CONDA_ENV."$args")
        $conda_file = $Global:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    echo "Backup Conda Env $conda_env to $conda_file"
    conda tree -n $conda_env leaves | sort > "$conda_file"
}

function clean_conda {
    if ( $args.Count -eq 0 ) {
        $conda_env = 'base'
        $conda_file = $Global:OX_OXIDE."bkceb"
    }
    elseif ( $args[0].ToString().Length -lt 2 ) {
        $conda_env = (echo $Global:OX_CONDA_ENV."$args")
        $conda_file = $Global:OX_OXIDE."bkce$args"
    }
    else {
        $conda_env = $args[0]
        $conda_file = $args[1]
    }

    echo "Cleanup Conda Env $conda_env by $conda_file"
    $the_leaves = (conda tree -n $conda_env leaves)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $conda_file | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            echo "Removing $line"
            . $Global:OX_CONDA remove -n $conda_env $line --quiet --yes
        }
    }
    if ($(echo $the_leaves | wc -w) -eq $(cat $conda_file | wc -w) -and ($(echo $the_leaves | wc -c)) -eq $(cat $conda_file | wc -c)) {
        echo "Conda Env Cleanup Finished"
    }
}

##########################################################
# packages
##########################################################

function ch { . $Global:OX_CONDA --help }
function ccf { . $Global:OX_CONDA config $args }
function cif { . $Global:OX_CONDA info }
function cis { . $Global:OX_CONDA install $args }
function cus { . $Global:OX_CONDA remove $args }
function csc { . $Global:OX_CONDA search $args }
function cdp { . $Global:OX_CONDA repoquery depends $pkg }
# specific
function cdpr { . $Global:OX_CONDA repoquery whoneeds $pkg }

# clean packages
function ccl {
    param ( $cmd )
    Switch ( $cmd ) {
        -l { . $Global:OX_CONDA clean --logfiles }
        -i { . $Global:OX_CONDA clean --index-cache }
        -p { . $Global:OX_CONDA clean --packages }
        -t { . $Global:OX_CONDA clean --tarballs }
        -f { . $Global:OX_CONDA clean --force-pkgs-dirs }
        -a { . $Global:OX_CONDA clean --all }
        Default {
            . $Global:OX_CONDA clean --packages
            . $Global:OX_CONDA clean --tarballs
        }
    }
}

# update packages
function cup {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { . $Global:OX_CONDA update --all }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        . $Global:OX_CONDA update --all -n $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else { . $Global:OX_CONDA update --all -n $the_env }
}

Remove-Item alias:cls -Force -ErrorAction SilentlyContinue
Remove-Item alias:clv -Force -ErrorAction SilentlyContinue
# list packages
# $1=name
function cls {
    param ( $the_env )
    if ( $the_env.Length -eq 0 ) { . $Global:OX_CONDA list }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        . $Global:OX_CONDA list -n $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else { . $Global:OX_CONDA list -n $the_env }
}

# list leave packages
# $1=name
function clv {
    param ( $the_env )
    if ( $the_env.Length -eq 0) { conda-tree leaves | sort }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        conda-tree -n $(echo $Global:OX_CONDA_ENV.$the_env) leaves | sort
    }
    else { conda-tree -n $the_env leaves | sort }
}

function cmt {
    param ( $the_env )
    $num_total = (cls $the_env | wc -l)
    echo "total: $num_total"
    $num_immature = (cls $the_env | rg -c "\s0\.\d")
    $ratio = $num_immature / $num_total * 100
    $mature_rate = '{0:N0}' -f $(100 - $ratio)
    echo "mature rate: $mature_rate %"
}

##########################################################
# extension
##########################################################

function cxa { . $Global:OX_CONDA config --add channels $args }
function cxrm { . $Global:OX_CONDA config --remove channels $args }
function cxls { . $Global:OX_CONDA config --get channels }

##########################################################
# project
##########################################################

function cii {
    switch ($Global:OX_CONDA) {
        conda { . $Global:OX_CONDA init $args }
        Default { . $Global:OX_CONDA shell init $args }
    }
}
function cr { . $Global:OX_CONDA run $args }

##########################################################
# environments
##########################################################

# check environment health
function cck {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { conda doctor }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        conda doctor -n $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else { conda doctor -n $the_env }
}

# activate environment: $1=name
function ceat {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) {
        . $Global:OX_CONDA2 activate base; clear
    }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        . $Global:OX_CONDA2 activate $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else {
        . $Global:OX_CONDA2 activate $the_env
    }
}

function ceq { . $Global:OX_CONDA2 deactivate; clear }
function cels { . $Global:OX_CONDA env list }

# reactivate environment: $1=name
function cerat {
    param ( $the_env )
    ceq
    ceat $the_env
}

# create environment: $1=name
function cecr {
    param ( $the_env )
    if ( $the_env.ToString().Length -lt 2 ) {
        . $Global:OX_CONDA create -n $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else {
        . $Global:OX_CONDA create -n $the_env
    }
    ceat $the_env
}

# delete environment: $1=name
function cerm {
    param ( $the_env )
    conda deactivate
    if ( $the_env.ToString().Length -lt 2 ) {
        . $Global:OX_CONDA env remove -n $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else { . $Global:OX_CONDA env remove -n $the_env }
}

# change environment subdir
function cesd {
    param ( $arch )
    Switch ( $arch ) {
        a { . $Global:OX_CONDA env config vars set CONDA_SUBDIR=win-arm64 }
        i { . $Global:OX_CONDA env config vars set CONDA_SUBDIR=win-64 }
    }
}

# export environment: $1=name
function ceep {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { $conda_env = base }
    elseif ( $the_env.ToString().Length -lt 2 ) {
        $conda_env = $(echo $Global:OX_CONDA_ENV.$the_env)
    }
    else { $conda_env = $the_env }
    . $Global:OX_CONDA env export -n $conda_env -f $env:OX_BACKUP\conda\$conda_env-win.yml
}

# rename environment
function cern {
    param ( $old, $new )
    if ( $old.Contains('\') ) { . $Global:OX_CONDA rename --prefix $old $new }
    else { . $Global:OX_CONDA rename --name $old $new }
}

function cedf { conda compare $args }
