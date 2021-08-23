#!/bin/bash

for i in {ruby,nodejs,rust,python,elm,groovy,elixir,erlang,clojure}
do
		asdf plugin add $i
done

asdf install
