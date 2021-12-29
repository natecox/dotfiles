#!/bin/bash

# Add plugins not found in the official list first
asdf plugin-add lein https://github.com/miorimmax/asdf-lein.git

while IFS=' ' read -r i _
do
    asdf plugin add $i
done < ~/.tool-versions

asdf install
