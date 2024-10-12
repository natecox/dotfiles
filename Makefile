.DEFAULT_GOAL: update

.PHONY: update test

update:
	nix flake update
	sudo nixos-rebuild switch --flake .#default

test:
	sudo nixos-rebuild test --flake .#default 
	
collect_garbage:
	sudo nix-collect-garbage --delete-older-than 14d
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
