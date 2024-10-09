.DEFAULT_GOAL: update

.PHONY: update test

update:
	sudo nixos-rebuild switch --flake .#default

test:
	sudo nixos-rebuild test --flake .#default 
	
