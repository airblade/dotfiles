#!/usr/bin/env bash

HOMEBREW_PREFIX=$(brew --prefix)

#
# Aliases
#


# Meta
alias ea='vim ~/dotfiles/bash/aliases'

alias ctags='$HOMEBREW_PREFIX/bin/ctags'

# Vim
alias m='mvim'

# Git
alias g='git'
alias gs='git stager'
alias gss='git status -s'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git l -10'
alias glb='git l HEAD ^main'

# Bundler
alias b='bundle'
alias bert='bundle exec rake test'

# Rails
alias log='less +F log/development.log'
alias r='bin/rails'
alias t='bin/rails test'

# Directories
alias lls='ls -l'
alias lsdot='ls -lAd .*'

# Changing directory
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Processes
alias topm='top -o vsize' # memory
alias topc='top -o cpu'   # cpu

# tree
alias tree='tree -C -F'

. ~/dotfiles/bash/project_aliases


#
# Environment variables
#

export HISTCONTROL=ignoredups
export HISTIGNORE="?:??"
export HISTFILESIZE=99999
export HISTSIZE=99999
export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/Applications/MacVim.app/Contents/bin:$PATH"
# Use full path; ~/bin breaks git's subcommand lookup for subcommands in ~/bin.
export PATH="/Users/andy/bin:$PATH"
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# After brew install curl-openssl:
# https://learnings.bolmaster2.com/posts/curl-openssl-tlsv1.3-on-macos.html
export PATH="/usr/local/opt/curl/bin:$PATH"

# Colourise the terminal.
export CLICOLOR=1

# less
# -F  exit when less than one screen of output
# -R  display colours
# -X  don't send terminal de(initialisation) strings;
#     prevents output being swallowed when exiting for -F.
# +F  go to end of file and wait for more data
export LESS='FRX'

# export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_COMMAND='fd --type f --color=never'

# Workaround Ruby errors when running Rails system tests.
# https://github.com/rbenv/ruby-build/issues/1385#issuecomment-643970208
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Ensure we do not load macOS's /etc/irbrc because it is obsolete.
export ETC_IRBRC_LOADED=true


#
# Functions
#

# List 10 most recently modified items in directory.
function lh {
  ls -lt "$@" | head -10;
}

function mcd {
  mkdir "$@" && cd "$_";
}

# Commit pending changes with args as message.
# e.g.: gc Fix ICBM launch bug.
#
# Ignore a trailing full stop.
function gc {
  if [ -n "$*" ]; then
    msg="$*"
    [ "${msg: -1:1}" == '.' ] && msg="${msg:0:-1}"
    git commit -m "$msg"
  else
    git commit
  fi
}
function gca {
  if [ -n "$*" ]; then
    msg="$*"
    [ "${msg: -1:1}" == '.' ] && msg="${msg:0:-1}"
    git add -A && git commit -m "$msg"
  else
    git add -A && git commit
  fi
}

# Copy Last Commit's SHA.
# The process substitution lets me send the output of cut to both
# pbcopy and standard out (the console in this case).
function clc {
  # git rev-parse --verify HEAD | cut -c1-7 | tr -d "\n" | tee >(pbcopy)
  git rev-parse --verify HEAD | cut -c1-7 | tr -d "\\n" | pbcopy
}

# open most recent rails migration
function mm {
  mvim db/migrate/"$(ls -1 db/migrate/ | tail -1)"
}


#
# Settings
#

set -o vi
shopt -s direxpand histappend histverify globstar nocaseglob no_empty_cmd_completion

# Ignore the tedious "you have new mail".
# Hmm, doesn't seem to prevent the message :(
unset MAILCHECK

shopt -s histappend
shopt -s cmdhist



#
#
#

# chruby
# slow? https://github.com/bluz71/dotfiles/blob/981f22a19c76a09c2f9e47f282a2347506bff8f9/bashrc#L280-L291
. "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
# Source auto.sh after setting default ruby
# https://github.com/iamvery/dotfiles/commit/822dd1ce632ec5e92801ba31a48357daffaa6a7b
. "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh"

test -e "${HOME}/.iterm2_shell_integration.bash" && . "${HOME}/.iterm2_shell_integration.bash"


#
# Completions
#

# brew install bash-completion@2
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

SSH_COMPLETE=( $(grep 'Host ' ~/.ssh/config | cut -f2 -d' ') )
complete -o default -W "${SSH_COMPLETE[*]}" ssh



#
# Prompt
#

# Looks like:
#
#   /path/to/current/directory/
#   $ 
#
# If we are in a Git repo the current branch and HEAD are shown like this:
#
#   /path/to/current/directory/  (branch_name)  abcd1234
#   $ 
#
# __git_ps1 is set up by the git-prompt.sh script bundled
# with the Git source.
#
#
# COLOURS
#
# Format: \[<sequence>\]
#
# 16-colour sequence: ESC[<code>m where <ESC> is \033
#
# 256-colour sequence: ESC[38;5;<fgcode>m and ESC<48;5;<bgcode>m
# 
# 256-colour codes are:
#
# 0x00-0x07: standard colors (as in ESC [ 30..37 m)
# 0x08-0x0F: high intensity colors (as in ESC [ 90..97 m)
# 0x10-0xE7: 6*6*6=216 colors: 16 + 36*r + 6*g + b (0≤r,g,b≤5)
# 0xE8-0xFF: grayscale from black to white in 24 steps
#
# See http://unix.stackexchange.com/a/124409/88207
#
 GREEN='\[\033[38;5;22m\]'
 RESET='\[\033[0m\]'
   RED='\[\033[38;5;88m\]'
  CYAN='\[\033[38;5;103m\]'
  BLUE='\[\033[38;5;4m\]'

# (*) unstaged changes
# (+) staged changes
export GIT_PS1_SHOWDIRTYSTATE=1
# ($) stashed changes
export GIT_PS1_SHOWSTASHSTATE=1
# (%) untracked files
export GIT_PS1_SHOWUNTRACKEDFILES=1

. /usr/local/etc/bash_completion.d/git-prompt.sh

git_head='git rev-parse --short HEAD 2>/dev/null'

function build_prompt {
  last="$?"
  if [ "$last" -eq 0 ]; then
    PS1="\\n$BLUE\\w/  $CYAN\$(__git_ps1)   $BLUE\$($git_head)\\n$GREEN$ $RESET"
  else
    PS1="\\n$BLUE\\w/  $CYAN\$(__git_ps1)   $BLUE\$($git_head)\\n$RED$ $RESET"
  fi
}

PROMPT_COMMAND="build_prompt; history -a"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

