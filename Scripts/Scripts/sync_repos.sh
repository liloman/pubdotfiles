#!/usr/bin/env bash

#Include libnotify
. ~/Scripts/libnotify

# Sync local repos dir 
readonly ROOT=~/Clones

#Change dir to $root
cd $ROOT

repo_failed() { notify_err "$1"; }

update_repo() {
    #Check for local changes
    dirty() { git status --porcelain; }

    if [[ $(dirty) ]]; then 
        echo "Unsaved changes,doing commit so."
        git add .
        lxterminal -l -e 'git commit -v; /bin/bash' || repo_failed $1
    fi

    #update refs for remote
    git remote -v update || { repo_failed " update for remote on repo $1"; return; }
    local LOCAL=$(git rev-parse @)
    local REMOTE=$(git rev-parse @{u})
    local BASE=$(git merge-base @ @{u})

    if [[ $LOCAL = $REMOTE ]]; then
        echo "Up-to-date"
    elif [[ $LOCAL = $BASE ]]; then
        echo "Needs to pull"
        git pull --rebase || repo_failed "pull failed for $1"
    elif [[ $BASE = $REMOTE ]]; then
        echo "Needs to push"
        git push || repo_failed "push failed for $1"
    else
        echo "Diverged notify user"
        repo_failed "repo $1 needs manual merge/rebase..."
    fi
}

do_others() {
    #Repos
    local others=" z "
    for dir in $others; do
        echo "**********************************"
        echo "Doing $dir"
        [[ ! -d $dir ]] && repo_failed "$dir not found" && continue
        cd $dir && update_repo $dir
        cd $ROOT
    done
}

do_mines() {
    #Repos
    local mines="dirty dirStack checkUndocumented generate-autocompletion pomodoroTasks"
    mines+=" pomodoroTasks2 rmalias easyPcRecovery kbp asyncBash warriors bash-surround"
    for dir in $mines; do
        echo "**********************************"
        echo "Doing $dir"
        [[ ! -d $dir ]] && repo_failed "$dir not found" && continue
        cd $dir && update_repo $dir
        cd $ROOT
    done
}

do_dotfiles(){
    echo "**********************************"
    echo "Doing dotfiles"
    cd ~/dotfiles && update_repo dotfiles || return 
    # update the desktop version without passwords
    ./install.sh -d -a
    cd $ROOT
}

do_yad(){
    echo "**********************************"
    echo "Doing yad"
    cd ~/Clones/yad || return 
    git svn rebase
    git push
    cd $ROOT

}

sync_repos() {
    do_mines
    do_dotfiles
    do_yad
    do_others
}

sync_repos
