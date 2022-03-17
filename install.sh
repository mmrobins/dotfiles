#!/bin/bash

# just targetting codespaces linux env for now
# but would be nice to make work on macos too...

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

# switch shells
sudo chsh -s "$(which zsh)" "$(whoami)"

dotfiles_dir=$(pwd)

apt-get install -y \
  fuse \
  fzf \
  jq \
  ripgrep \
  universal-ctags \
  yamllint

# Install vim plugins
vim +'PlugInstall --sync' +qa
