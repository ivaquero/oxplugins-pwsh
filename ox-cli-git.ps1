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

# git republish
function grpbl() {
    git remote add origin $args[0]
    $dbranch = $(get_default_branch)
    git pull $args[0] $dbranch
    git push --set-upstream origin $dbranch
}

# clean files
function gcl {
    git reset --hard HEAD~1
    $dbranch = $(get_default_branch)
    git checkout --orphan origin/$dbranch
    git add -A
    git commit -am "🎉 New Start"
    git branch -D $dbranch
    git branch -m $dbranch
    git push -f origin $dbranch
}
