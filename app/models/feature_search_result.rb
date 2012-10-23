class FeatureSearchResult
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :id, :scenarios, :highlight   
  
  def initialize(attributes = {})
    @scenarios = Array.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
end