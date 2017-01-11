#!/bin/bash

# coala Docker Image entrypoint script
# This script is run if there's no command being passed

PREFIX="\033[1;34m>> \033[0m"
ADDITIONAL_BEARS_DIR="/additional_bears"

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
    msg "You can also define an additional bear directory, like this:"
    msg "docker run coala/base --volume=\$(pwd):/work" \
        "--volume\$(pwd)/mybears:$ADDITIONAL_BEARS_DIR --workdir=/work [command]"

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

# Check if additional bears folder exists
if [[ -d $ADDITIONAL_BEARS_DIR ]]; then
    msg "Additional bears directory present," \
        "Adding it to additional bear directories"
    COALA_ARGS="$COALA_ARGS --bear-dirs $ADDITIONAL_BEARS_DIR"
fi

# Run coala non-interactively
msg "Running coala non-interactively ..."
exec coala $COALA_ARGS --non-interactive
