.DEFAULT_GOAL = update
NIX_ENV := $(shell command -v nix-env 2> /dev/null)
NIX_INSTALLER := $(shell command -v /nix/nix-installer 2> /dev/null)
NIX_BUILD := $(shell command -v nix-build 2> /dev/null)
DARWIN_REBUILD := $(shell command -v darwin-rebuild 2> /dev/null)
HOME_MANAGER := $(shell command -v home-manager 2> /dev/null)

.PHONY : \
	install update uninstall \
	install_nix update_nix uninstall_nix \
	install_darwin update_darwin \
	install_directories commit_changes

install: install_nix install_directories

update: update_nix update_darwin update_home_manager collect_garbage

uninstall: uninstall_nix

install_nix:
	$(info "Installing nix using determinate systems installer...")
ifndef NIX_ENV
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
else
	$(info "	...already installed, skipping.")
endif

update_nix:
	$(info "Updating nix...")
	@nix flake update
	# @sudo launchctl remove org.nixos.nix-daemon
	# @sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

collect_garbage:
	$(info "Collecting garbage...")
	@nix-store --gc

uninstall_nix:
	$(info "Uninstalling nix using determinate systems installer...")
ifdef NIX_INSTALLER
	@echo "Uninstalling nix using determinate systems installer..."
	/nix/nix-installer uninstall
else
	$(info "	...installer not found, skipping.")
endif

install_darwin:
	$(info "Installing darwin...")
ifndef DARWIN_REBUILD
	nix build .#darwinConfigurations.$$(hostname -s).system --extra-experimental-features "nix-command flakes"
	printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
	sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	./result/sw/bin/darwin-rebuild switch --flake .
else
	$(info "	...already installed, skipping")
endif

install_home_manager:
	$(info "Installing home manager...")
ifndef HOME_MANAGER
	nix build .#homeConfigurations.$$(whoami).activationPackage --extra-experimental-features "nix-command flakes"
	nix run . -- build --flake .
else
	$(info "	...already installed, skipping")
endif	

update_darwin:
ifdef DARWIN_REBUILD
	$(info "Rebuilding darwin...")
	darwin-rebuild switch --flake .
endif

update_home_manager:
ifndef DARWIN_REBUILD
	$(info "Rebuilding home-manager...")
	home-manager switch --flake .
endif

install_directories:
	$(info "Installing standard user directories...")
	@mkdir -p ~/src

commit_changes:
	@if ! git diff --exit-code flake.lock 2> /dev/null; then \
		git commit -m "Lockfile update" flake.lock; \
		git push; \
	fi
	
	
