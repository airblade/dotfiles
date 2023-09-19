if [ -f ~/.bashrc ];
then
  source ~/.bashrc
fi

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh

# Source auto.sh after setting default ruby
# https://github.com/iamvery/dotfiles/commit/822dd1ce632ec5e92801ba31a48357daffaa6a7b
source /usr/local/opt/chruby/share/chruby/auto.sh

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# After brew install curl-openssl:
# https://learnings.bolmaster2.com/posts/curl-openssl-tlsv1.3-on-macos.html
export PATH="/usr/local/opt/curl/bin:$PATH"
