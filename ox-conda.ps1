##########################################################
# config
##########################################################

$Global:OX_OXYGEN.oxc = "$env:OXIDIZER\defaults\.condarc"
# config files
$Global:OX_ELEMENT.c = "$HOME\.condarc"
# backup files
$Global:OX_OXIDE.bkc = "$env:OX_BACKUP\conda\.condarc"

if (Get-Command mamba -ErrorAction SilentlyContinue) {
    $Global:OX_CONDA="mamba"
}
else {
    $Global:OX_CONDA="conda"
}

function up_conda {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $conda_env = 'base'
        $conda_file = "$Global:OX_OXIDE.bkceb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        $conda_env = $Global:OX_CONDA_ENV.$the_env
        $conda_file = "$Global:OX_OXIDE.bkce$the_env"
    }
    else {
        $conda_env = $the_env
        $conda_file = $the_file
    }

    echo "Update Conda Env $conda_env by $conda_file"
    $pkg = (cat $conda_file | sd "`n" ' ')
    echo "Installing $pkg"
    Invoke-Expression ". $Global:OX_CONDA install $pkgs"
}

function back_conda {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $conda_env = 'base'
        $conda_file = "$Global:OX_OXIDE.bkceb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        $conda_env = $Global:OX_CONDA_ENV.$the_env
        $conda_file = "$Global:OX_OXIDE.bkce$the_env"
    }
    else {
        $conda_env = $the_env
        $conda_file = $the_file
    }

    echo "Backup Conda Env $conda_env to $conda_file"
    conda tree -n $conda_env leaves  > "$conda_file"
}

function clean_conda {
    param ( $the_env, $the_file )
    if ([string]::IsNullOrEmpty( $the_env )) {
        $conda_env = 'base'
        $conda_file = "$Global:OX_OXIDE.bkceb"
    }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        $conda_env = $Global:OX_CONDA_ENV.$the_env
        $conda_file = "$Global:OX_OXIDE.bkce$the_env"
    }
    else {
        $conda_env = $the_env
        $conda_file = $the_file
    }

    echo "Cleanup Conda Env $conda_env by $conda_file"
    $the_leaves = (conda tree -n $conda_env leaves)

    ForEach ( $line in $the_leaves ) {
        $pkg = (cat $conda_file | rg $line)
        if ([string]::IsNullOrEmpty($pkg)) {
            . $Global:OX_CONDA uninstall -n $conda_env $line --quiet --yes
        }
    }
    if ($(echo $the_leaves | wc -w) -eq $(cat $conda_file | wc -w)) -and ($(echo $the_leaves | wc -c) -eq $(cat $conda_file | wc -c)) {
        echo "Conda Env Cleanup Finished"
    }
}

##########################################################
# packages
##########################################################

function ch { conda --help }
function ccf { conda config $args }
function cif { conda info }
function cis { . $Global:OX_CONDA install $args }
function cus { . $Global:OX_CONDA uninstall $args }
function csc { . $Global:OX_CONDA search $args }
function cdp { . $Global:OX_CONDA repoquery depends $pkg }
# specific
function crdp { . $Global:OX_CONDA repoquery whoneeds $pkg }

# clean packages
function ccl {
    param ( $cmd )
    Switch ( $cmd ) {
        -l { conda clean --logfiles }
        -i { conda clean --index-cache }
        -p { conda clean --packages }
        -t { conda clean --tarballs }
        -f { conda clean --force-pkgs-dirs }
        -a { conda clean --all }
        Default {
            conda clean --packages
            conda clean --tarballs
        }
    }
}

# update packages
function cup {
    if ([string]::IsNullOrEmpty( $args[1] )) { . $Global:OX_CONDA update --all }
    else {
        ceat $args[1]
        . $Global:OX_CONDA update --all $args[2]
        conda deactivate
    }
}

Remove-Item alias:cls -Force -ErrorAction SilentlyContinue
Remove-Item alias:clv -Force -ErrorAction SilentlyContinue
# list packages
# $1=name
function cls {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { conda list }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        conda list -n $Global:OX_CONDA_ENV.$the_env
    }
    else { conda list -n $the_env }
}

# list leave packages
# $1=name
function clv {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { conda-tree leaves }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        conda-tree -n $Global:OX_CONDA_ENV.$the_env leaves
    }
    else { conda-tree -n $the_env leaves }
}

function cmt {
    param ( $the_env )
    $num_total = (cls $the_env | wc -l)
    echo "total: $num_total"
    $num_immature = (cls $the_env | rg '\s0\.\d' | wc -l)
    $ratio = $num_immature / $num_total * 100
    $mature_rate = '{0:N0}' -f $(100 - $ratio)
    echo "mature rate: $mature_rate %"
}

##########################################################
# extension
##########################################################

function cxa { conda config --add channels $args }
function cxrm { conda config --remove channels $args }
function cxls { conda config --get channels }

##########################################################
# project
##########################################################

function cii { conda init $args }
function cr { conda run $args }

##########################################################
# environments
##########################################################

# activate environment: $1=name
function ceat {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) {
        conda activate base; clear
    }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        conda activate $Global:OX_CONDA_ENV.$the_env; clear
    }
    else {
        conda activate $the_env; clear
    }
}

# reactivate environment: $1=name
function cerat {
    param ( $the_env )
    conda deactivate
    ceat $the_env
}

# create environment: $1=name
function cecr {
    param ( $the_env )

    if ( $(echo $the_env | wc -L) -lt 2 ) {
        conda create -n $Global:OX_CONDA_ENV.$the_env
    }
    else {
        conda create -n $the_env
    }
    ceat $the_env
}

# delete environment: $1=name
function cerm {
    param ( $the_env )
    conda deactivate
    if ( $(echo $the_env | wc -L) -lt 2 ) {
        conda env remove -n $Global:OX_CONDA_ENV.$the_env
    }
    else { conda env remove -n $the_env }
}

# change environment subdir
function cesd {
    param ( $arch )
    Switch ( $arch ) {
        a { conda env config vars set CONDA_SUBDIR=win-arm64 }
        i { conda env config vars set CONDA_SUBDIR=win-64 }
    }
}

# export environment: $1=name
function ceep {
    param ( $the_env )
    if ([string]::IsNullOrEmpty( $the_env )) { $conda_env = base }
    elseif ( $(echo $the_env | wc -L) -lt 2 ) {
        $conda_env = $Global:OX_CONDA_ENV.$the_env
    }
    else { $conda_env = $1 }
    conda env export -n $conda_env -f $env:OX_BACKUP\install\$conda_env-win.yml
}

# rename environment
function cern {
    param ( $old, $new )
    if ( $old.Contains('\') ) { conda rename --prefix $old $new }
    else { conda rename --name $old $new }
}
function cels { conda env list }
function ceq { conda deactivate; clear }
function cedf { conda compare $args }
