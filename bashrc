source ~/dotfiles/bash/env
source ~/dotfiles/bash/completions
for f in ~/dotfiles/bash/completion_scripts/*; do source $f; done
source ~/dotfiles/bash/aliases
source ~/dotfiles/bash/fns
source ~/dotfiles/bash/prompt
source ~/dotfiles/bash/config

if [ `uname` = "Darwin" ]; then
  source ~/dotfiles/bash/osx
  source ~/dotfiles/bash/project_aliases
fi
