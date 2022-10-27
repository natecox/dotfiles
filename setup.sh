#!/bin/bash

echo () {
    command echo "$(tput setaf 6)---> $1$(tput sgr 0)"
}

### Install nix
if ! command -v nix-env &> /dev/null
then
  sh <(curl -L https://nixos.org/nix/install)
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  nix-env -iA nixpkgs.stow
fi

### add unstable channel
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --update

### Install nix-darwin
if ! command -v darwin-rebuild &> /dev/null
then
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update

  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer

  rm -rf $HOME/.nixpkgs
fi

### Install emacs, this is hopefully temporary. Would prefer to have it in darwin.
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use emacs-osx
nix-env -iA emacsOsxNative -f https://github.com/sagittaros/emacs-osx/archive/refs/tags/built.tar.gz
sudo rm -rf /Applications/Emacs.app
sudo cp -rL ~/.nix-profile/Applications/Emacs.app /Applications

### Copy symlinks via stow
cd ${0%/*}

echo "Stowing files..."

for dir in */; do
    stow $dir --no-folding
done

echo "Creating standard directories..."
mkdir ~/org
mkdir ~/src

echo "Done!"
