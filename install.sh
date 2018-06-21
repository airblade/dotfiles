#!/usr/bin/env bash
#
# Installs the dotfiles into the user's home directory.
#
# NOTE: the bash dotfiles assume a layout of ~/dotfiles

set -eo pipefail

# Directory in which this script is located.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


handle() {
  source="$1"
  filename="${source##*/}"

  if [ "$filename" == "dotfiles" ]; then return; fi
  if [ -z "$filename" ]; then return; fi

  target="$HOME/$filename"

  # We could use `ln -i` to prompt user if the target file exists
  # but it doesn't take account of the target being what we want anyway.

  if [ -e "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      echo skip: "$source" → "$target"
    else
      read -r -n 1 -p "overwrite $target (y/n)? " answer
      echo
      case "$answer" in
        y|Y)
          # I can't get -nF to remove target when it is a directory.
          # So manually remove instead.
          rm -r "$target" && ln -s "$source" "$target" && echo link: "$source" → "$target"
          ;;
        *)
          echo skip: "$source"
          ;;
      esac
    fi
  else
    ln -s "$source" "$target" && echo link: "$source" → "$target"
  fi
}


# Instead of listing filenames and then reading the list,
# just execute something for each file.
export -f handle
find "$DIR" -maxdepth 1             \
            -not -name .DS_Store    \
            -not -name .git         \
            -not -name bash         \
            -not -name README.md    \
            -not -name install.sh   \
            -exec bash -c 'handle "$0"' {} \;

