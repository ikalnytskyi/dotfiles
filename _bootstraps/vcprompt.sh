#!/bin/sh

#
# Checkout latest version of `vcprompt`, compile it and
# install into local binary dir: $DOTFILES_DIR/bin/.bin
#

HG_REPO="https://bitbucket.org/gward/vcprompt"

DOTFILES_DIR=$(dirname `readlink -f $0`)/..
INSTALL_DIR=$DOTFILES_DIR/bin/.bin


# check for hg
if ! which hg >/dev/null; then
    echo "ABORTED: please install mercurial"
    exit 1
fi

# check for autoconf
if ! which autoconf >/dev/null; then
    echo "ABORTED: please install autoconf"
    exit 1
fi

# get sources
temp_dir=`mktemp -d`
hg clone $HG_REPO $temp_dir
cd $temp_dir

# compile
autoconf
./configure
make

# install
cp vcprompt $INSTALL_DIR/
