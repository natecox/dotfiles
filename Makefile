.DEFAULT_GOAL: update

.PHONY: update test

update:
	nix flake update
	sudo nixos-rebuild switch --flake .#default

test:
	sudo nixos-rebuild test --flake .#default 
	
