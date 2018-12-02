#!/bin/sh

run_command ()
{
    if ! "$@" ; then
        echo this failed: "$@" 1>&2
        echo in dir `pwd` 1>&2
        exit 1
    fi
}

do_git_tree ()
{
    local where=$1 ; shift || return
    local url=$1 ; shift || return
    local branch_or_tag=${1-} # optional
    local reponame
    local pw

    case "${branch_or_tag-}" in
        origin/master) branch_or_tag="";; # this is not a branch
    esac

    pw=${PWD-`pwd`}

    case "$where" in
        */*) run_command mkdir -p ${where%/*};;
    esac

    if ! [ -d "$where" ] ; then
        # you cannot use --branch here because it doesn't take
        # sha256 commit ids
        echo doing git clone "$url" "$where"
        run_command git clone "$url" "$where"
        if [ -n "$branch_or_tag" ] ; then
            echo doing git checkout $branch_or_tag
            cd $where && run_command git checkout $branch_or_tag
            cd $pw
        fi
    else
        cd "$where"
        echo doing git fetch in $PWD
        run_command git fetch
        if [ -n "$branch_or_tag" ] ; then
            echo doing git checkout $branch_or_tag in $PWD
            run_command git checkout -q $branch_or_tag
            echo doing git pull in $PWD
            run_command git pull
        else
            echo doing git pull in $PWD
            run_command git pull
        fi
        cd "$pw"
    fi
    (cd "$where"
        echo HEAD in `pwd` is:
        git rev-parse --verify HEAD
        git log --pretty=format:'%h' -n 1
        git status
        git log -n 2
    ) | cat
}

do_git_tree "$@"

exit 0

path=$1
url=$2
revision=$3
label=$4

#set -x

echo Updating git repo at \'$path\'

gitCloneIt () {
   git clone "$url" "$path" || exit $?
}

waitForYes () {
    while true; do
        read -p "Type 'yes' to continue: " response
        case $response in
            yes* ) break;;
            * ) echo "Please answer 'yes' or press C-c to cancel the entire process.";;
        esac
    done
}

# if .git is a file, then we assume it's a git submodule and clean it up
if [ -f "$path/.git" ]; then
    echo "WARNING: \"$path\" seems to hold the remains of a git submodule (the old scheme). Do you want me to *RECURSIVELY DELETE* this directory, and then check out the git repo using the new scheme?"
    waitForYes
    rm -rf "$path"
    rm -rf ".git/modules/$path"
    git config -f .git/config --remove-section "submodule.$path" 2> /dev/null
elif [ -d "$path/.git" ]; then
    currentRemoteUrl=`git --git-dir "$path/.git" remote get-url origin`
    if [ "$currentRemoteUrl" != "$url" ]; then
        # Getting the repo can be slow and unreliable if the servers are loaded...
        #echo "WARNING: \"$path\" seems to be holding a checkout from a different URL (current: \"$currentRemoteUrl\", requested: \"$url\"). Do you want me to *RECURSIVELY DELETE* this directory, and then check out the git repo from the new location?"
        #waitForYes
        #rm -rf "$path"

        # Alternatively, change the url of 'origin' remote
        echo "WARNING: \"$path\" seems to be holding a checkout from a different URL (current: \"$currentRemoteUrl\", requested: \"$url\"). I'm changing the 'origin' remote url to the new one."
        git --git-dir "$path/.git" remote set-url origin "$url"
    fi
fi

if [ ! -e "$path" ]; then
    gitCloneIt
fi

cd "$path" || exit $?

if ([ -n "$revision" ] && ! (git cat-file -e "$revision" 2> /dev/null)) ||
   ([ -n "$label" ]    && ! (git cat-file -e "$label" 2> /dev/null)); then
    git fetch origin || exit $?
fi

if [ -n "$label" ]; then
    git checkout --quiet "$label" || exit $?
fi

if [ -n "$revision" ]; then
    git reset --quiet --merge "$revision" || exit $?
fi

# Print the locally modified files as a reminder
git status --short
