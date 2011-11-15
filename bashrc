source ~/dotfiles/bash/env
source ~/dotfiles/bash/aliases
source ~/dotfiles/bash/completions
source ~/dotfiles/bash/fns
source ~/dotfiles/bash/config

if [ `uname` = "Darwin" ]; then
  source ~/dotfiles/bash/osx
  source ~/dotfiles/bash/project_aliases
fi
