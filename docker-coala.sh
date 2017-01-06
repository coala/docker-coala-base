#!/bin/bash

# coala Docker Image entrypoint script
# This script is run if there's no command being passed

PREFIX="\033[1;34m>> \033[0m"

function msg {
    echo -e "$PREFIX$@"
}

# Declare this is a dumb terminal
# because by default docker doesn't create a pseudo-tty
export TERM="dumb"

# Check if the working directory is changed from the default
if [[ "$(pwd)" == "/" ]]; then
    msg "It looks like you forgot to define a working directory\n"
    msg "To properly use this Docker Image,"
    msg "You have to bind your project to this container and" \
        "set the working directory to the container-side bind, like this:"
    msg "docker run coala/base --volume=\$(pwd):/work --workdir=/work [command]"

    exit 1
fi

# Check if .gitignore exists
# See https://github.com/coala/coala-quickstart/issues/49
if [[ ! -f .gitignore ]]; then
    msg "It looks like there's no .gitignore file," \
        "Creating a blank one ..."

    touch .gitignore
fi

# Check if .coafile exists
if [[ ! -f .coafile ]]; then
    msg ".coafile doesn't exist," \
        "Running coala-quickstart to create one ..."

    coala-quickstart --non-interactive
fi

# Run coala non-interactively
msg "Running coala non-interactively ..."
coala --non-interactive
