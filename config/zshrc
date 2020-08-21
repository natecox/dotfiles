setopt HIST_FIND_NO_DUPS

# Fresh shell
source ~/.fresh/build/shell.sh

# Antigen (https://github.com/zsh-users/antigen)
# Install with `brew install antigen`
source $(brew --prefix)/share/antigen/antigen.zsh
antigen init $HOME/.antigenrc

# ASDF
. $HOME/.asdf/asdf.sh

# Yarn (https://yarnpkg.com/)
export PATH="$(brew --prefix yarn)/bin:$PATH"

# Import personal aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Setup Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

export PLATFORM_DEV=$HOME/src/platform/dev
shovel() ( $PLATFORM_DEV/script/run shovel "$@"; )

cmssh() ( sft ssh "$@".cmmint.net; )

eval "$(starship init zsh)"

export PATH="$HOME/.bin:$PATH"
