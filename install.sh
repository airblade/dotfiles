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

  if [[ $filename == "dotfiles" ]]; then return; fi

  target="$HOME/$filename"

  # We could use `ln -i` to prompt user if the target file exists
  # but it doesn't take account of the target being what we want anyway.

  if [ -e "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      echo skip: "$source" → "$target"
    else
      read -u 3 -r -n 1 -p "overwrite $target (y/n)? " answer
      case "$answer" in
        y|Y)
          ln -Ffs "$source" "$target" && echo link: "$source" → "$target"
          ;;
        *)
          echo skip: "$source" → "$target"
          ;;
      esac
    fi
  else
    ln -s "$source" "$target" && echo link: "$source" → "$target"
  fi
}


# Loop over files and directories in dotfiles directory.
#
# This approach handles spaces etc in filenames (which shouldn't really be necessary here).
#
# Note in order to read input from user inside the loop, we redirect stdin to file
# descriptor 3.  Otherwise the input would be consumed from the list of filenames.
while IFS=  read -r -d $'\0'; do
  handle "$REPLY"
done 3<&0 < <(find "$DIR" -maxdepth 1 \
              -not -name .DS_Store    \
              -not -name .git         \
              -not -name bash         \
              -not -name README.md    \
              -not -name install.sh   \
              -print0                 \
             )

