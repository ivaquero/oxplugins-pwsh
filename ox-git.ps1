##########################################################
# config
##########################################################

# default files
$Global:OX_OXYGEN.oxg = "$env:OXIDIZER\defaults\.gitconfig"
# system files
$Global:OX_ELEMENT.g = "$HOME\.gitconfig"

##########################################################
# project management
##########################################################

# git republish
function grpbl() {
    git remote add origin $args[0]
    if ([string]::IsNullOrEmpty($args[1])) { $branch = master }
    else { $branch = $args[1] }
    git pull $args[0] $branch
    git push --set-upstream origin $branch
}

##########################################################
# repository management
##########################################################

# clean files
function gcl {
    git reset --hard HEAD~1
    if ([string]::IsNullOrEmpty($args[0])) { $branch = master }
    else { $branch = $args[0] }
    git checkout --orphan origin/$branch
    git add -A
    git commit -am "🎉 New Start"
    git branch -D $branch
    git branch -m $branch
    git push -f origin $branch
}
