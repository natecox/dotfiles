HIBERNATE_FILE := /sys/firmware/efi/efivars/HibernateLocation-*

.DEFAULT_GOAL: update

.PHONY: update test config config_darwin collect_garbage clear_hibernate

update: update_nixos update_darwin update_home_manager collect_garbage
config: config_darwin
test: test_nixos

	
# -- NixOS, the opterating system

NIXOS_REBUILD := $(shell command -v nixos-rebuild 2> /dev/null)

update_nixos: clear_hibernate
ifdef NIXOS_REBUILD
	$(info "Updating NixOS...")
	sudo chown -R $$(whoami):users .git/objects/
	nix flake update
	sudo nixos-rebuild switch --flake .#default
endif

test_nixos: clear_hibernate
ifdef NIXOS_REBUILD
	sudo nixos-rebuild test --flake .#default 
endif


# -- Nix, the package manager

NIX_ENV := $(shell command -v nix-env 2> /dev/null)
NIX_INSTALLER := $(shell command -v /nix/nix-installer 2> /dev/null)

install_nix:
ifndef NIX_ENV
	$(info "Installing nix using determinate systems installer...")
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
endif

uninstall_nix:
ifdef NIX_INSTALLER
	$(info "Uninstalling nix using determinate systems installer...")
	/nix/nix-installer uninstall
endif



# -- Darwin, for macOS compatibility

DARWIN_REBUILD := $(shell command -v darwin-rebuild 2> /dev/null)

install_darwin:
ifndef DARWIN_REBUILD
	$(info "Installing darwin...")
	nix build .#darwinConfigurations.$$(hostname -s).system --extra-experimental-features "nix-command flakes"
	
	./result/sw/bin/darwin-rebuild switch --flake .
else
	$(info "	...already installed, skipping")
endif

update_darwin:
ifdef DARWIN_REBUILD
	$(info "Rebuilding darwin...")
	@nix flake update --impure
	@darwin-rebuild switch --flake .
endif

config_darwin:
ifdef DARWIN_REBULID
	$(info "Reconfiguring darwin...")
	@darwin-rebuild switch --flake .
endif
	


# -- Home manager, the dotfile manager

HOME_MANAGER := $(shell command -v home-manager 2> /dev/null)

install_home_manager:
ifndef HOME_MANAGER
	$(info "Installing home manager...")
	nix build .#homeConfigurations.$$(whoami).activationPackage --extra-experimental-features "nix-command flakes"
	nix run . -- build --flake .
endif	

update_home_manager:
ifdef HOME_MANAGER
	$(info "Rebuilding home-manager...")
	@home-manager switch --flake .
endif



# -- Utilites 

# Clear unnecessary cruft
collect_garbage:
	nix-collect-garbage --delete-older-than 14d
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system

# Fixes an issue where hibernation wakeup fails and leaves behind a file, which will prevent updates
clear_hibernate:
ifneq ("$(wildcard $(HIBERNATE_FILE))","")
	$(info "Clearing hibernate file...")
	sudo chattr -i $(HIBERNATE_FILE)
	sudo rm $(HIBERNATE_FILE)
endif

# Commits changes to the lockfile, if they exist
commit_changes:
	@if ! git diff --exit-code flake.lock 2> /dev/null; then \
		git commit -m "Lockfile update" flake.lock; \
		git push; \
	fi
