#!/bin/bash

echo () {
    command echo "$(tput setaf 6)---> $1$(tput sgr 0)"
}

### Copy symlinks via stow

cd ${0%/*}

echo "Stowing files..."

for dir in */; do
    stow $dir --no-folding
done

### Configure mac apps

echo "Installing from brewfile..."

cat $HOME/Brewfile.* | brew bundle --file=- # merge all brewfiles in home and install

### Make necessary directories

echo "Creating standard directories..."
mkdir ~/org
touch ~/org/.projectile
mkdir ~/src

### Configure ASDF

echo "Configuring ASDF..."

# Add plugins not found in the official list first
asdf plugin-add lein https://github.com/miorimmax/asdf-lein.git

while IFS=' ' read -r i _
do
    asdf plugin add $i
done < ~/.tool-versions

asdf install

echo "Done!"
