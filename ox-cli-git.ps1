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

# clean branch
git_clean_branch {
    param ( $branch, $obj )
    Switch ( $branch ) {
        -f { $list = "-l"; $flag = "-D"; find = "$obj" }
        -r { $list = "-r"; $flag = "-r -d"; find = "$branch" }
        -rf { $list = "-l"; $flag = "-d"; find = "$branch" }
        Default { bw get item $obj --pretty }
    }

    ForEach ( $br in $(git branch "$list" | rg "$find") ){
        git branch "$flag" "$br"
    }
    git branch "$list"
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
