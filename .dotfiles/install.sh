#!/usr/bin/env bash

export DOTFILES_HOME=$HOME/.dotfiles

if [ -e "$DOTFILES_HOME" ]; then
  backupFilename="$DOTFILES_HOME.$(date +%F).backup"
  echo "Backing up existing $DOTFILES_HOME to $backupFilename"
  mv "$DOTFILES_HOME" "$backupFilename"
fi

git clone --bare https://github.com/jwhitaker/dotfiles.git $HOME/.dotfiles
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles restore --staged .
dotfiles restore .

dotfiles config status.showUntrackedFiles no