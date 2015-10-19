#!/usr/bin/env bash

# bash will exist whenever it encounters a failure
set -e

# To run in debug mode, uncomment the following line
#set -x

JOB_SEARCH_ROOT="${HOME}/.job_search"
GITHUB="https://github.com/crazcalm/job-search.git"

# checkout function uses git to clone the repo.
# "$1" = link to the github repo
# "$2" = The directory path where the repo will be cloned to. 
# "!" = negation
# "-d" = Checks to see if that directory exists
function checkout {
    if [ ! -d "$2" ];then
        git clone "$1" "$2"
    else
        echo "Exited because \"${2}\" already exits"
        exit 2
    fi
}

# Need to check to see if the shell is variable is Null
# I believe "-z" makes sure that the string is not empty
if [ -z "$SHELL" ]; then
    echo 'A shell argument was not used (Ex: bash)'
    exit 2
fi

# Need to define the "$PROFILE" variable based on the shell used.
# Note: The bash shell has been tested, but not the others...
case "$SHELL" in
/bin/bash)
    PROFILE="~/.bashrc"
    ;;
/bin/zsh)
    PROFILE="~/.zshrc"
    ;;
/bin/ksh)
    PROFILE="~/.profile"
    ;;
fish)
    PROFILE="~/.config/fish/config.fish"
    ;;
*)
    PROFILE="profile"
    ;;
esac


# Need to check if "git" is installed on this computer
# Checks to see if the git commands exists
if ! command -v git 1>/dev/null 2>&1; then
    echo "job-search: Git is not installed. Cannot continue." & >2
    exit 2
else
    echo -e "\n\n"
    checkout ${GITHUB} ${JOB_SEARCH_ROOT}
fi

{
    echo -e "\n\nUse job-search from any directory by"
    echo -e "creating an alias in your ${PROFILE}\n\n"

    # Give them and example of creating an alias
    case "${SHELL}" in
    /bin/bash)
        # Add an example of creating an alias
        echo -e "alias job-search=\"python3 ${JOB_SEARCH_ROOT}/jobs.py\"\n\n"
        ;;
    *)
        echo -e "Look up how to create alias in your shell\n\n"
        ;;
    esac
}
