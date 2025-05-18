##########################################################
# config
##########################################################

# backup files
if ([string]::IsNullOrEmpty("$env:OX_BACKUP/text")) {
    mkdir "$env:OX_BACKUP/text"
}

function up_texlive {
    Write-Output "Update TeXLive by $env:OX_OXIDE.bktl"
    $file = (cat $env:OX_OXIDE.bktl)

    ForEach ( $line in $file ) {
        Write-Output "Installing $line"
        tlmgr install $line
    }
}

function back_texlive {
    Write-Output "Backup TeXLive to $env:OX_OXIDE.bktl"
    tlmgr list --only-installed | rg -o 'collection-\w+' | rg -v 'basic' > "$env:OX_OXIDE.bktl"
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
