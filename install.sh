#!/bin/bash

# log all the things
exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

# switch shells
sudo chsh -s "$(which zsh)" "$(whoami)"

dotfiles_dir=$(pwd)
os=$(uname -s)

# Install packages
if [ "$os" == "Darwin" ]; then
  brew bundle
else
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
vim +'PlugInstall --sync' +qa
