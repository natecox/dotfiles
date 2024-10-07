.DEFAULT_GOAL: update

.PHONY: update

update:
	sudo nixos-rebuild switch --flake .#default
