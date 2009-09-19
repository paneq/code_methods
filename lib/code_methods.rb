$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

#
# Usage: Use when you want to have easy access to some dictionary
#        that is stored in database via generated methods.
#
# class PaymentType < ActiveRecord::Base
#   include CodeMethods.based_on(:code)
# end
#
# Result:
#
# if your payment_types database table has column named 'code' and is populated with
# three records whose codes are: 'ADJUSTMENT', 'MONTHLY_FEE' and 'PENALTY' then
# such methods will be generated
#
# PaymentType.ADJUSTMENT
# PaymentType.MONTHLY_FEE
# PaymentType.PENALTY
#
# Calling method PaymentType.PENALTY is equal to calling
# Payment.find_by_code('PENALTY')
# 
module CodeMethods
  VERSION = '1.0.0'

  def self.column_name
    @@c_name ||= 'code'
    @@c_name
  end

  def self.column_name=(name)
    @@c_name = name
  end

  def self.included(klass)
    column = self.column_name

    class_methods = Module.new do
      method_name = "find_by_#{column}"

      klass.find(:all).each do |active_record_obj|
        code = active_record_obj.send(column)
        define_method(code) do
          send(method_name, code)
        end
      end

    end

    klass.extend(class_methods)
  end

  # include CodeMethods.based_on(:code)
  def self.based_on(column_name)
    clonned_module = self.clone
    clonned_module.column_name = column_name
    clonned_module
  end

end

