require 'rubygems'
require 'wirble'
require 'irb/completion'
require 'pp'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true  # to assist tab completion somehow
IRB.conf[:PROMPT][ IRB.conf[:PROMPT_MODE] ][:RETURN] = "=> %s\n\n"

# Next line suppresses printing of return values.
# Posted to Ruby-Talk by Ara T Howard.
# -- Seems to cause Mongrel (but not script/console) to spew errors on console --
#IRB.conf[:PROMPT][ IRB.conf[:PROMPT_MODE] ][:RETURN]=''

Wirble.init
Wirble.colorize

class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def paste
  `pbpaste`
end

def ep
  eval paste
end


# http://ozmm.org/posts/time_in_irb.html
# Use like unix's time command.
# E.g. >> time { sleep 1 }
def time(times = 1)
  require 'benchmark'
  ret = nil
  Benchmark.bm { |x| x.report { times.times { ret = yield } } }
  ret
end

# FastRi integration.
# http://eigenclass.org/hiki/irb+ri+completion
# http://mislav.caboo.se/rails/faster-ri-documentation/
require 'irb/completion'

RICompletionProc = proc{|input|
  bind = IRB.conf[:MAIN_CONTEXT].workspace.binding
  case input
  when /(\s*(.*)\.ri_)(.*)/
    pre = $1
    receiver = $2
    meth = $3 ? /\A#{Regexp.quote($3)}/ : /./ #}
    begin
      candidates = eval("#{receiver}.methods", bind).map do |m|
        case m
        when /[A-Za-z_]/; m
        else # needs escaping
          %{"#{m}"}
        end
      end
      candidates = candidates.grep(meth)
      candidates.map{|s| pre + s }
    rescue Exception
      candidates = []
    end
  when /([A-Z]\w+)#(\w*)/ #}
    klass = $1
    meth = $2 ? /\A#{Regexp.quote($2)}/ : /./
    candidates = eval("#{klass}.instance_methods(false)", bind)
    candidates = candidates.grep(meth)
    candidates.map{|s| "'" + klass + '#' + s + "'"}
  else
    IRB::InputCompletor::CompletionProc.call(input)
  end
}
#Readline.basic_word_break_characters= " \t\n\"\\'`><=;|&{("
Readline.basic_word_break_characters= " \t\n\\><=;|&"
Readline.completion_proc = RICompletionProc

# Load ~/.railrc if appropriate.
# http://ozmm.org/posts/railsrc.html
load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']


# http://themomorohoax.com/2009/04/07/ruby-irb-tip-try-again-faster

def ls
  %x{ls}.split "\n"
end

# File load.
def fl(file_name)
  file_name += '.rb' unless file_name =~ /\.rb/
  @@recent = file_name
  load "#{file_name}"
end

# Reloads the last file you loaded.
def rl
  fl @@recent
end

# Retry.  Reloads the last file loaded and re-runs the last command you tried.
def rt
  rl
  eval choose_last_command
end

def choose_last_command
  real_last = Readline::HISTORY.to_a[-2]
  real_last == 'rt' ? @@saved_last : (@@saved_last = real_last)
end


# Colour conversion
def hex(*decimals)
  hexes = decimals.map { |d| '%02x' % d }
  out = "##{hexes.join}"
  copy out
  puts "copied #{out}"
end

def rgb(hex)
  decimals = hex.scan(/../).map { |h| h.to_i 16 }
  out = decimals.join ', '
  copy out
  puts "copied #{out}"
end
