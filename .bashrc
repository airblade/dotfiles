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


# Workaround Ruby errors when running Rails system tests.
# https://github.com/rbenv/ruby-build/issues/1385#issuecomment-643970208
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# source ~/.stripe/stripe-completion.bash
