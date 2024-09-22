##########################################################
# config
##########################################################

# default files
$Global:OX_OXYGEN.oxg = "$env:OXIDIZER\defaults\.gitconfig"
# system files
$Global:OX_ELEMENT.g = "$HOME\.gitconfig"

##########################################################
# repository management
##########################################################

function get_default_branch() {
    git remote show origin | grep 'HEAD branch' | cut -d ' ' -f5
}

function git_squash {
    git reset --soft HEAD~$args[0]
    git add -A
}

# git republish
function git_repub {
    git remote add origin $args[0]
    $branch_d = $(get_default_branch)
    git pull $args[0] $branch_d
    git push --set-upstream origin $branch_d
}

# git sync
function git_sync {
    $branch_d=$(get_default_branch)
    git pull upstream $branch_d
    git push origin $branch_d
}

# clean files
function git_clean_history {
    git reset --hard HEAD~1
    $branch_d = $(get_default_branch)
    git checkout --orphan origin/$branch_d
    git add -A
    git commit -am "🎉 New Start"
    git branch -D $branch_d
    git branch -m $branch_d
    git push -f origin $branch_d
}
