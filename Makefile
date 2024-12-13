HIBERNATE_FILE := /sys/firmware/efi/efivars/HibernateLocation-*

.DEFAULT_GOAL: update

# .PHONY: update test collect_garbage clear_hibernate

update: update_nixos update_darwin update_home_manager collect_garbage

	
# -- NixOS, the opterating system

NIXOS_REBUILD := $(shell command -v nixos-rebuild 2> /dev/null)

update_nixos: clear_hibernate
ifdef NIXOS_REBUILD
	sudo chown -R $$(whoami):users .git/objects/
	nix flake update
	sudo nixos-rebuild switch --flake .#default
endif

test_nixos: clear_hibernate
	sudo nixos-rebuild test --flake .#default 



# -- Nix, the package manager

NIX_ENV := $(shell command -v nix-env 2> /dev/null)
NIX_INSTALLER := $(shell command -v /nix/nix-installer 2> /dev/null)

install_nix:
	$(info "Installing nix using determinate systems installer...")
ifndef NIX_ENV
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
else
	$(info "	...already installed, skipping.")
endif

uninstall_nix:
	$(info "Uninstalling nix using determinate systems installer...")
ifdef NIX_INSTALLER
	@echo "Uninstalling nix using determinate systems installer..."
	/nix/nix-installer uninstall
else
	$(info "	...installer not found, skipping.")
endif



# -- Darwin, for macOS compatibility

DARWIN_REBUILD := $(shell command -v darwin-rebuild 2> /dev/null)

install_darwin:
	$(info "Installing darwin...")
ifndef DARWIN_REBUILD
	nix build .#darwinConfigurations.$$(hostname -s).system --extra-experimental-features "nix-command flakes"
	
	./result/sw/bin/darwin-rebuild switch --flake .
else
	$(info "	...already installed, skipping")
endif

update_darwin:
ifdef DARWIN_REBUILD
	$(info "Rebuilding darwin...")
	@nix flake update
	@darwin-rebuild switch --flake .
endif



# -- Home manager, the dotfile manager

HOME_MANAGER := $(shell command -v home-manager 2> /dev/null)

install_home_manager:
	$(info "Installing home manager...")
ifndef HOME_MANAGER
	nix build .#homeConfigurations.$$(whoami).activationPackage --extra-experimental-features "nix-command flakes"
	nix run . -- build --flake .
else
	$(info "	...already installed, skipping")
endif	

update_home_manager:
ifndef DARWIN_REBUILD
	$(info "Rebuilding home-manager...")
	@home-manager switch --flake .
endif



# -- Utilites 

# Clear unnecessary cruft
collect_garbage:
	sudo nix-collect-garbage --delete-older-than 14d
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system

# Fixes an issue where hibernation wakeup fails and leaves behind a file, which will prevent updates
clear_hibernate:
	$(info "Clearing hibernate file...")
ifneq ("$(wildcard $(HIBERNATE_FILE))","")
	sudo chattr -i $(HIBERNATE_FILE)
	sudo rm $(HIBERNATE_FILE)
endif

# Commits changes to the lockfile, if they exist
commit_changes:
	@if ! git diff --exit-code flake.lock 2> /dev/null; then \
		git commit -m "Lockfile update" flake.lock; \
		git push; \
	fi
