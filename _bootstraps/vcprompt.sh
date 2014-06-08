#!/bin/sh

#
# Checkout latest version of `vcprompt`, compile it and
# install into local binary dir: $DOTFILES_DIR/bin/.bin
#

SCRIPT_NAME=`basename $0`
SCRIPT_DIR=`dirname $0`

DOTFILES_DIR="$SCRIPT_DIR/.."
INSTALL_DIR="$DOTFILES_DIR/bin/.bin"

HG_REPO="https://bitbucket.org/gward/vcprompt"


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
temp_dir=`mktemp -d /tmp/${SCRIPT_NAME}.XXX`
hg clone $HG_REPO $temp_dir


# compile
pushd $temp_dir
  autoconf
  ./configure
  make
popd


# install
echo "\nInstalling binary to $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp "$temp_dir/vcprompt" "$INSTALL_DIR/"
