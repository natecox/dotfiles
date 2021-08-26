#!/bin/bash

while IFS=' ' read -r i _
do
    asdf plugin add $i
done < ~/.tool-versions

asdf install
