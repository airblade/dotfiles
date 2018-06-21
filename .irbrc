require 'irb/completion'
require 'irb/ext/save-history'

# Save-history does not work out of the box.
# http://stackoverflow.com/questions/2065923/irb-history-not-working
# http://www.ruby-forum.com/topic/189523
# /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/site_ruby/1.8/irb/ext/save-history.rb
IRB.conf[:SAVE_HISTORY] = 500
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')
IRB.conf[:PROMPT_MODE]  = :SIMPLE

%w[ rubygems interactive_editor ].each do |gem|
  begin
    require gem
  rescue LoadError
    puts "Failed to load #{gem} gem."
  end
end

# Use awesome_print as the default formatter.
begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError
  puts 'awesome_print unavailable :('
end

class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  # http://github.com/rtomayko/dotfiles/blob/rtomayko/.irbrc
  def ls(obj=self)
    width = `stty size 2>/dev/null`.split(/\s+/, 2).last.to_i
    width = 80 if width == 0
    local_methods(obj).each_slice(3) do |meths|
      pattern = "%-#{width / 3}s" * meths.length
      puts pattern % meths
    end
  end

end

# http://ozmm.org/posts/railsrc.html
if defined?(Rails) && Rails.env
  load File.dirname(__FILE__) + '/.railsrc-irb'
end

class Object
  def interesting_methods
    case self.class
    when Class;  self.public_methods.sort - Object.public_methods
    when Module; self.public_methods.sort - Module.public_methods
    else         self.public_methods.sort - Object.new.public_methods
    end
  end
end
