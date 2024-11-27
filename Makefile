.DEFAULT_GOAL: update

HIBERNATE_FILE := /sys/firmware/efi/efivars/HibernateLocation-*

.PHONY: update test collect_garbage clear_hibernate

update: clear_hibernate update_flake collect_garbage

update_flake:
	sudo chown -R $$(whoami):users .git/objects/
	nix flake update
	sudo nixos-rebuild switch --flake .#default

test:
	sudo nixos-rebuild test --flake .#default 
	
collect_garbage:
	sudo nix-collect-garbage --delete-older-than 14d
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system

clear_hibernate:
ifneq ("$(wildcard $(HIBERNATE_FILE))","")
	sudo chattr -i $(HIBERNATE_FILE)
	sudo rm $(HIBERNATE_FILE)
endif
