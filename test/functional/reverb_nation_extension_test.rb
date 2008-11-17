require File.dirname(__FILE__) + '/../test_helper'

class ReverbNationExtensionTest < Test::Unit::TestCase
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'reverb_nation'), ReverbNationExtension.root
    assert_equal 'Reverb Nation', ReverbNationExtension.extension_name
  end
  
end
