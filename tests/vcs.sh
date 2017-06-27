#!/bin/sh

# This script verifies that VCS fetching is possible,
# even after the Dockerfile ruthlessly removes parts
# of the VCS packages because they have lots of
# unnecessary dependencies for unneeded features.

set -e -x

cd /tmp;
svn co https://github.com/githubtraining/hellogitworld.git;
bzr branch lp:govcstestbzrrepo;
hg clone https://bitbucket.org/fracai/empty-hg;
