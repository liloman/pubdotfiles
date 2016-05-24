#!/usr/bin/env bash
#Join several tasks in one
# cozy to make your TODO lists on a project

taskjoin() {
    addtasks() {
        local id=
        local pro=
        # joinning to active task
        if [[ $active == y ]]; then
            [[ $opt =~ (.*\])([[:digit:]]*) ]]
            pro=${BASH_REMATCH[1]: 1:-1}
            id=${BASH_REMATCH[2]}
        fi
        for arg; do
            if [[ $active == y ]]; then
                task add "$arg" pro:"$pro" dep:$id
            else
                pro=$opt
                task add "$arg" pro:"$pro"
                active=y
            fi
            #get last id. import to sort it due dependencies...
           id=$(task _unique id | sort -n |  tail -n 1)
        done
        task
    }
    local i=0
    local -a projects
    local -a joins
    local active=n

    echo "Where do you want to join the tasks from:"
    select from in "Active task" "Any project";
    do
        case $from in
            Active*)
                for id in $(task _ids); do
                    project=$(task _get $id.project)
                    description=$(task _get $id.description)
                    projects[$((++i))]="[$project]$id-$description"
                done
                active=y
                break;;
            Any*)
                echo "Projects:"
                while IFS= read -r project; do
                    projects[$((++i))]=$project
                done <<< "$(task rc.list.all.projects=1 _projects)" 
                break;;
        esac
    done

    select opt in "${projects[@]}";do
        [[ -n $opt ]]  && break 
    done
    echo -n "The new tasks are going to be joined with the "
    [[ $active == y ]] && echo " task $opt" || echo " project $opt"

    i=0
    while true; do
        read  -p "Enter a desc or q to exit:"  new
        [[ $new == q ]] && break
        joins[$((++i))]=$new
    done

    for idx in ${!joins[@]}; do
        echo "$idx) ${joins[$idx]}"
    done
    echo "Are you sure you want to join these tasks?"
    select yn in Yes No; do
        case $yn in
            Y* )  addtasks "${joins[@]}"; break;;
            N* ) echo "Exit."; break;;
        esac
    done
}

taskjoin

