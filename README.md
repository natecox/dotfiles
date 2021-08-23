# Nate Cox's Dotfiles

## Preamble
This repo uses [zero.sh](https://github.com/zero-sh/zero.sh) for system setup and
configuration.

## Installation

```sh
$ git clone --recursive https://github.com/natecox/dotfiles ~/.dotfiles
$ caffeinate ~/.dotfiles/zero/setup
```

**Note**: it may be necessary to log in to the App Store before running, as
`brew bundle` will invoke [`mas`](https://github.com/mas-cli/mas) which requires
it.
