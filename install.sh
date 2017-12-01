#! /bin/sh

platform=$(uname -s)
if [ $platform = "Darwin" ]; then IS_OSX="1"; fi

user=$(whoami)
CHECK=✔
DONE="${CHECK} DONE."

if [ -z "$IS_OSX" ]; then
    BASEDIR=$(readlink -e $(dirname $0))
else
    echo "Not implemented for OSX"
    exit 1
fi
echo "Running emacs install from $BASEDIR"


link_emacs_to_emacsd() {
    echo "Install emacs configuration files to $HOME/.emacs.d"
    ln -i -v -s $BASEDIR $HOME/.emacs.d
    echo "$DONE"
}

install_emacs() {
    if [ -z $IS_OSX ]; then
	install_emacs_linux
    else
	install_emacs_osx
    fi
}

install_emacs_osx() {
    echo "Not implemented. Exiting."
    exit 1
}

install_emacs_linux() {
    echo "Installing emacs package..."
    sudo add-apt-repository ppa:kelleyk/emacs
    sudo apt-get update
    sudo apt-get install emacs25
    echo "$DONE"
}

install() {
    install_emacs
    link_emacs_to_emacsd
}
