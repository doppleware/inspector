class ScenarioSearchResult
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :id, :highlight, :tag_ids
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @tag_ids = Array.new
  end
  
  def persisted?
    false
  end
end