##########################################################
# config
##########################################################

# backup files
$Global:OX_OXIDE.bktl = "$env:OX_BACKUP\tex\texlive-pkgs.txt"

function up_texlive {
    echo "Update TeXLive by $($Global:OX_OXIDE.bktl)"
    $file = (cat $($Global:OX_OXIDE.bktl))
    $num = (cat $($Global:OX_OXIDE.bktl) | wc -l)

    pueue group add texlive_update
    pueue parallel $num -g texlive_update

    ForEach ( $line in $file ) {
        echo "Installing $line"
        pueue add -g texlive_update "tlmgr install $line"
    }

    pueue wait -g texlive_update
    pueue status
}

function back_texlive {
    echo "Backup TeXLive to $($Global:OX_OXIDE.bktl)"
    tlmgr list --only-installed | rg --only-matching 'collection-\w+' | rg --invert-match 'basic' > "$($Global:OX_OXIDE.bktl)"
}

##########################################################
# packages
##########################################################

function tlup { tlmgr update --all }
function tlups { tlmgr update --all --self }
function tlck { tlmgr check }
function tlis { tlmgr install $args }
function tlus { tlmgr remove $args }
function tllsa { tlmgr list $args }
function tlls { tlmgr list --only-installed }
function tlif { tlmgr info $args }
function tlifc { tlmgr info collections }
function tlifs { tlmgr info schemes }
function tlh { tlmgr -h }
