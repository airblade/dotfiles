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
export FZF_DEFAULT_COMMAND='rg --files --hidden'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#source /Users/andy/Library/Preferences/org.dystroy.broot/launcher/bash/br
