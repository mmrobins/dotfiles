#!/bin/bash

# log all the things
exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x


dotfiles_dir=$(pwd)
os=$(uname -s)

# Install packages
if [ "$os" == "Darwin" ]; then
  brew bundle
else
  # already zsh by default on macos these days
  # switch shells
  chsh -s "$(which zsh)" "$(whoami)"

  apt-get update -y
  apt-get install -y \
    ack \
    fuse \
    fzf \
    jq \
    ripgrep \
    tree \
    universal-ctags \
    yamllint
fi

# symlink files
declare -a ln_files=(
  .ackrc
  .bash_profile
  .bashrc
  .editrc
  .gemrc
  .git-completion.sh
  .gitconfig
  .gitignore
  .gnupg/gpg-agent.conf
  .inputrc
  .irbrc
  .sh_aliases
  .shrc
  .tmux.conf
  .vim
  .vimrc
  .zprofile
  .zshenv
  .zshrc
)
for link_file in "${ln_files[@]}"; do
  ln -sfn $dotfiles_dir/$link_file $HOME/$link_file
done

# Install vim plugins
# extra flags to ignore startup errors
# https://stackoverflow.com/questions/54606581/ignore-all-errors-in-vimrc-at-vim-startup
vim -E -s -u ~/.vimrc +PlugInstall +qall
