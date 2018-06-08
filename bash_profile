if [ -f ~/.bashrc ];
then
  source ~/.bashrc
fi

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.5.0

# Source auto.sh after setting default ruby
# https://github.com/iamvery/dotfiles/commit/822dd1ce632ec5e92801ba31a48357daffaa6a7://github.com/iamvery/dotfiles/commit/822dd1ce632ec5e92801ba31a48357daffaa6a7b 
source /usr/local/opt/chruby/share/chruby/auto.sh

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
