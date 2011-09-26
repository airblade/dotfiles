# Based on Ryan Bates:
# http://github.com/ryanb/dotfiles/blob/master/Rakefile

require 'rake'

desc "install the dot files into user's home directory"
task :install do
  @replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.md LICENSE].include? file
    process file
  end
end

def process(file)
  puts "processing #{file}"
  if File.exist? dot(file)
    if File.identical? file, dot(file)
      puts "identical ~/.#{file}"
    elsif @replace_all
      replace_file(file)
    else
      print "overwrite ~/.#{file}? [ynaq] "
      case $stdin.gets.chomp
      when 'a'
        @replace_all = true
        replace_file(file)
      when 'y'
        replace_file(file)
      when 'q'
        exit
      else
        puts "skipping ~/.#{file}"
      end
    end
  else
    link_file(file)
  end
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end

def dot(file)
  File.join ENV['HOME'], ".#{file}"
end
