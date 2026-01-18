#!/usr/bin/env bash

export DOTFILES_HOME=$HOME/.dotfiles

FORCE_INSTALL=${FORCE_INSTALL:-false}

install_dotfiles() {
  echo "Installing dotfiles to $DOTFILES_HOME"

  git clone --bare https://github.com/jwhitaker/dotfiles.git $HOME/.dotfiles

  function dotfiles {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
  }

  dotfiles restore --staged .
  dotfiles restore .

  dotfiles config status.showUntrackedFiles no
}

backup_existing_dotfiles() {
  backupFilename="$DOTFILES_HOME.$(date +%F).backup"
  echo "Backing up existing $DOTFILES_HOME to $backupFilename"
  mv "$DOTFILES_HOME" "$backupFilename"
} 

check_for_dotfiles() {
  echo "Checking for existing dotfiles in $DOTFILES_HOME"

  if [ -e "$DOTFILES_HOME" ]; then
    echo "Dotfiles already installed in $DOTFILES_HOME"
    echo "If you want to reinstall, set FORCE_INSTALL=true and run this script again."
    exit 1
  else
    echo "No existing dotfiles found in $DOTFILES_HOME"
  fi
}

if [ "$FORCE_INSTALL" = true ]; then
  if [ -e "$DOTFILES_HOME" ]; then
    backup_existing_dotfiles
  fi
else
  check_for_dotfiles
fi

install_dotfiles

