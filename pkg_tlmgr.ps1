##########################################################
# config
##########################################################

# backup files
if ([string]::IsNullOrEmpty("$Global:OX_BACKUP/text")) {
    mkdir "$Global:OX_BACKUP/text"
}

function up_texlive {
    Write-Output "Update TeXLive by $Global:OX_OXIDE.bktl"
    $file = (cat $Global:OX_OXIDE.bktl)

    ForEach ( $line in $file ) {
        Write-Output "Installing $line"
        tlmgr install $line
    }
}

function back_texlive {
    Write-Output "Backup TeXLive to $Global:OX_OXIDE.bktl"
    tlmgr list --only-installed | rg -o 'collection-\w+' | rg -v 'basic' > "$Global:OX_OXIDE.bktl"
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
