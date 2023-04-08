NIX_ENV := $(shell command -v nix-env 2> /dev/null)
NIX_INSTALLER := $(shell command -v /nix/nix-installer 2> /dev/null)
NIX_BUILD := $(shell command -v nix-build 2> /dev/null)
DARWIN_REBUILD := $(shell command -v darwin-rebuild 2> /dev/null)

install: install_nix install_directories update_symlinks install_darwin

update: update_nix update_symlinks update_darwin

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
	@nix-channel --update
	@nix-env -iA nixpkgs.nix
	@sudo launchctl remove org.nixos.nix-daemon
	@sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

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
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
	nix-channel --update

	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
else
	$(info "	...already installed, skipping")
endif

update_darwin:
	$(info "Rebuilding darwin...")
ifdef DARWIN_REBUILD
	darwin-rebuild switch
else
	$(info "	...darwin not installed, skipping")
endif

install_directories:
	$(info "Installing standard user directories...")
	@mkdir -p ~/{src,org}

update_symlinks:
	$(info "Stowing files...")
	@nix-env -iA nixpkgs.stow
	$(shell for dir in */; do stow $$dir --no-folding; done)
