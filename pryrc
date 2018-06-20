require 'awesome_print'
AwesomePrint.pry!

ActiveRecord::Base.instance_eval { alias :/ :find } if defined? ActiveRecord
