#!/usr/bin/env bash

export DOT_HOME=$HOME/.dot

FORCE_INSTALL=${FORCE_INSTALL:-false}

install_dot() {
  echo "Installing dot to $DOT_HOME"

  git clone --bare https://github.com/jwhitaker/dot.git $DOT_HOME

  function dot {
    /usr/bin/git --git-dir=$DOT_HOME/ --work-tree=$HOME $@
  }

  dot restore --staged .
  dot restore .

  dot config status.showUntrackedFiles no

  echo "dot is installed.  restart your terminal or run 'source ~/.zshrc' to start using it."
}

backup_existing_dot() {
  now=$(date "+%Y-%m-%dT%H:%M:%S")
  backupFilename="$DOT_HOME.$now.backup"

  echo "Backing up existing $DOT_HOME to $backupFilename"
  mv "$DOT_HOME" "$backupFilename"
} 

check_for_dot() {
  echo "Checking for existing dotfiles in $DOT_HOME"

  if [ -e "$DOT_HOME" ]; then
    echo "Dotfiles already installed in $DOT_HOME"
    echo "If you want to reinstall, set FORCE_INSTALL=true and run this script again."
    exit 1
  else
    echo "No existing dotfiles found in $DOT_HOME"
  fi
}

if [ "$FORCE_INSTALL" = true ]; then
  if [ -e "$DOT_HOME" ]; then
    backup_existing_dot
  fi
else
  check_for_dot
fi

install_dot

