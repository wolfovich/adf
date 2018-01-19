# $:.unshift File.dirname(__FILE__)

require "builder"
# require "activesupport/date"

# # little extension to DateTime to have a method that returns the time in ISO 8601 format
# class DateTime
#   def iso_8601
#     self.strftime("%Y-%m-%dT%H:%M:%S") << self.strftime("%z").gsub(/(\d{2})(\d{2})/, '\1:\2')
#   end
# end

# ADF is a utility class and the namespace for all of the model classes
class ADF
  module InitializedModel
    def initialize options = {}
      options.each { |k,v| instance_variable_set "@#{k}", v }
    end

    def foo
      'FOO'
    end
  end
  # get an ADF::Prospect from an ADF formatted XML string
  def self.parse adf
    ADF::Prospect.from_adf adf
  end

end

require "adf/prospect"
require "adf/address"
require "adf/contact"
require "adf/customer"
require "adf/vehicle"
require "adf/vendor"
require "adf/version"
require "adf/provider"
require "adf/colorcombination"
require "adf/finance"
require "adf/option"
require "adf/timeframe"