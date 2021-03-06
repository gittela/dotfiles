#!/usr/bin/env zsh
set -x

# Init
# Detect OS
os="dunno"
unamestr=$(uname)
if [[ "$unamestr" == "Linux" ]]; then
  distrostr=$(lsb_release -si)
  if [[ "$distrostr" =~ /RedHat/ ]]; then
    os="redhat"
  elif [[ "$distrostr" =~ /Fedora/ ]]; then
    os="redhat"
  else
    os=$distrostr
  fi
elif [[ "$unamestr" == "Darwin" ]]; then
  os=$unamestr
  if ! type "brew" > /dev/null; then
    # Install homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
else
  os=$unamestr
fi

install_pkg() {
  if [[ "$os" == "Darwin" ]]; then
    $(brew install $1)
  elif [[ "$os" == "redhat" ]]; then
    $(sudo yum install $1)
  elif [[ "$os" == "Ubuntu" ]]; then
    $(sudo apt-get install $1)
  else
    echo "Unknown OS, cannot install $1"
  fi
}

# Install curl, if missing
if ! type "curl" > /dev/null; then
  install_pkg curl
fi

install_dotfiles() {
  if [ -d ~/.dotfiles ]
  then
    cd ~/.dotfiles
    git pull
  else
    git clone https://github.com/tg90nor/dotfiles.git ~/.dotfiles
  fi
}

# Make vim awesome
vim_conf() {
  # Copy .vimrc
  rm ~/.vimrc || true
  ln -s ~/.dotfiles/vimrc ~/.vimrc
  # Install vundle
  mkdir -p ~/.vim/bundle
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  # Create directories to hold vim backup, swap, undo and view files
  mkdir -p ~/.vim/backup ~/.vim/swap ~/.vim/undo ~/.vim/view
}

# Make tmux awesome
tmux_conf() {
  # Check if tmux is installed, and install if not
  if ! type "tmux" > /dev/null; then
    install_pkg tmux
  fi
  # Copy .tmux.conf
  rm ~/.tmux.conf || true
  ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
}

# Make zsh awesome
zsh_conf() {
  # Install prezto
  if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/tg90nor/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  else
    cd ~/.zprezto
    git pull && git submodule update --init --recursive
  fi
  # Copy .zshrc
  rm ~/.zshrc || true
  ln -s ~/.dotfiles/zshrc ~/.zshrc
  # Copy .zpreztorc
  rm ~/.zpreztorc || true
  ln -s ~/.dotfiles/zpreztorc ~/.zpreztorc
}

populate_bin() {
  mkdir -p ~/bin
  rm ~/bin/dotupdate || true
  rm ~/bin/createdb || true
  rm ~/bin/mkpw || true
  ln -s ~/.dotfiles/bin/* ~/bin/
}

# Install rvm and ruby
rvm() {
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable
  rvm install 2.2
  rvm use 2.2 --default
}

install_dotfiles
vim_conf
tmux_conf
zsh_conf
populate_bin
#rvm
