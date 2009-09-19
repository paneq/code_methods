require File.dirname(__FILE__) + '/test_helper.rb'

class TestCodeMethods < Test::Unit::TestCase

  # Tested class that behaves a bit like ActiveRecord::Base
  class Tested < Struct.new(:code, :type)

    A_BOY = new(:BOY, :NAUGHTY)
    A_GIRL = new(:GIRL,:CRAZY)

    INSTANCES = [
      A_BOY,
      A_GIRL
    ]

    # simulates find(:all) call
    def self.find(*params)
      INSTANCES
    end

    def self.find_by_code(code)
      INSTANCES.find{|i| i.code == code}
    end

    def self.find_by_type(type)
      INSTANCES.find{|i| i.type == type}
    end
    
  end
  
  def test_generating_methods
    Tested.instance_eval do
      include CodeMethods
    end

    assert_equal Tested::A_BOY, Tested.BOY()
    assert_equal Tested::A_GIRL, Tested.GIRL()

    Tested.instance_eval do
      include CodeMethods.based_on(:type)
    end

    assert_equal Tested::A_BOY, Tested.NAUGHTY()
    assert_equal Tested::A_GIRL, Tested.CRAZY()
    assert_equal Tested::A_BOY, Tested.BOY()
    assert_equal Tested::A_GIRL, Tested.GIRL()
  end

end
