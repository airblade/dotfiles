source ~/dotfiles/bash/env
for f in ~/dotfiles/bash/completions/*; do source $f; done
source ~/dotfiles/bash/aliases
source ~/dotfiles/bash/fns
source ~/dotfiles/bash/prompt
source ~/dotfiles/bash/config

if [ `uname` = "Darwin" ]; then
  source ~/dotfiles/bash/osx
  source ~/dotfiles/bash/project_aliases
fi

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag -l --nocolor --hidden -g""'

