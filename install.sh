#!/bin/bash

# log all the things
exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x


dotfiles_dir=$(pwd)
os=$(uname -s)

# Install packages
if [ "$os" == "Darwin" ]; then
  #brew bundle
  echo 'darwin'
else
  # already zsh by default on macos these days
  # switch shells
  sudo chsh -s "$(which zsh)" "$(whoami)"

  sudo apt-get update -y
  packages=(
    ack
    fd-find
    fuse
    fzf
    jq
    libfuse2
    neovim
    netcat
    ripgrep
    ruby-dev
    socat
    tree
    universal-ctags
    yamllint
  )
  for pkg in "${packages[@]}"; do
    sudo apt-get install -y "$pkg" || echo "Warning: failed to install $pkg"
  done

  # https://github.com/sharkdp/fd#on-ubuntu
  ln -s $(which fdfind) ~/bin/fd

  curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  chmod a+x $HOME/bin/nvim
fi

if [ "$CODESPACES" = true ] ; then
  # make clipper stale socket cleanup work after disconnects
  if grep -qxF 'StreamLocalBindUnlink yes' /etc/ssh/sshd_config; then
    echo 'sshd StreamLocalBindUnlink already set'
  else
    echo 'StreamLocalBindUnlink yes' | sudo tee -a /etc/ssh/sshd_config
    sudo pkill -HUP -F /var/run/sshd.pid
    echo 'StreamLocalBindUnlink set for sshd_config'
  fi
  # makes it possible to forward my private GPG key via SSH https://wiki.gnupg.org/AgentForwarding
  gpg --import mattrobinson.gpg.pub
fi

mkdir $HOME/.config

# symlink files
declare -a ln_files=(
  .ackrc
  .bashrc
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
  bin
)
for link_file in "${ln_files[@]}"; do
  ln -sfn $dotfiles_dir/$link_file $HOME/$link_file
done

# Install vim plugins
# extra flags to ignore startup errors
# https://stackoverflow.com/questions/54606581/ignore-all-errors-in-vimrc-at-vim-startup
vim -E -s -u ~/.vimrc +PlugInstall +qall

# hacky, probably a better way, but I want this for my prompt
if [ ! -f ~/.codespace_created_at ]; then
  echo $(date +'%Y%m%d-%H%M') > ~/.codespace_created_at
fi

# nvm was easier to install than nodenv ¯\_(ツ)_/¯
# need newer version to run copilot on nvim
# Node.js version 16.x or newer required but found 12.22.12
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
#nvm install 18.13.0
