require 'test/unit'
# Load the environment
unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["RADIANT_ENV_FILE"]
    require ENV["RADIANT_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/radiant/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end
require "#{RADIANT_ROOT}/test/test_helper"

class Test::Unit::TestCase
  
  # Include a helper to make testing Radius tags easier
  test_helper :extension_tags
  
  # Add the fixture directory to the fixture path
  self.fixture_path << File.dirname(__FILE__) + "/fixtures"
  
  # Add more helper methods to be used by all extension tests here...
  
end

require 'context'
require 'stump'

# override stump's proxy code to account for optional parameters

class Object
  def proxy_existing_method(method, options = {}, &block)
    method_alias = "__old_#{method}"
    
    meta_eval do
      module_eval("alias #{method_alias} #{method}")
    end
    
    check_arity = Proc.new do |args|
      arity = method(method_alias.to_sym).arity
      if ((arity >= 0 && args.length != arity) ||
          (args.length < (-arity - 1)))
        # no way to check for too many optional params
        raise ArgumentError
      end
    end
    
    behavior = if options[:return]
                  lambda do |*args| 
                    check_arity.call(args)
                    
                    Stump::Mocks.verify([self, method])

                    if method(method_alias.to_sym).arity == 0
                      send(method_alias)
                    else
                      send(method_alias, *args)
                    end

                    return options[:return]
                  end
                else
                  lambda do |*args| 
                    check_arity.call(args)

                    Stump::Mocks.verify([self, method])
                    
                    if method(method_alias.to_sym).arity == 0
                      return send(method_alias)
                    else
                      return send(method_alias, *args)
                    end
                  end
                end

    meta_def method, &behavior
  end
end
