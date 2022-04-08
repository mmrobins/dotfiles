#!/bin/bash

# log all the things
exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x


dotfiles_dir=$(pwd)
os=$(uname -s)

mkdir -p ~/bin

# Install packages
if [ "$os" == "Darwin" ]; then
  #brew bundle
  echo "foo"
else
  # already zsh by default on macos these days
  # switch shells
  sudo chsh -s "$(which zsh)" "$(whoami)"

  apt-get update -y
  apt-get install -y \
    ack \
    fd-find \
    fuse \
    fzf \
    jq \
    libfuse2 \
    neovim \
    netcat \
    socat \
    ripgrep \
    ruby-dev \
    tree \
    universal-ctags \
    yamllint

  # https://github.com/sharkdp/fd#on-ubuntu
  ln -s $(which fdfind) ~/bin/fd

  curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  chmod a+x $HOME/bin/nvim
fi

# symlink files
declare -a ln_files=(
  .ackrc
  .clipper.json
  .config/nvim
  .ctags.d
  .ctags
  .editrc
  .gemrc
  .git-completion.sh
  .gitconfig
  .gitconfig-github
  .gitignore
  .gnupg/gpg-agent.conf
  .inputrc
  .rgconfig
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
