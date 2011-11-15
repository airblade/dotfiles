#!/bin/bash
#
# Installs the dotfiles into the user's home directory.
#
# NOTE: the bash dotfiles assume a layout of ~/dotfiles

set -e

# Directory in which this script is located.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for file in *; do
  if [ $file = "README.md" ]; then
    continue
  fi

  sourcefile="${DIR}/${file}"
  dotfile="$HOME/.${file}"

  if [ -e "${dotfile}" ]; then
    if [ $replace_all ]; then
      ln -fs "${sourcefile}" "${dotfile}"
    else
      echo -n "replace ${dotfile}? [ynaq] "
      read keypress
      case "$keypress" in
        "y" ) ln -nfs "${sourcefile}" "${dotfile}" ;;
        "n" ) continue ;;
        "a" )
          replace_all="yes"
          ln -nfs "${file}" "${dotfile}"
        ;;
        "q" ) exit 0 ;;
      esac
    fi
  else
    ln -s "${sourcefile}" "${dotfile}"
  fi
done

echo "Installed dotfiles in $HOME"
