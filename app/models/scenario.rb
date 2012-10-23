class Scenario < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :feature, :inverse_of => :scenarios

  searchable do
    text :name, :stored => true, :boost => 5.0
    text :description
    text :feature_name, :stored => true do
      feature.name
    end
    string(:feature_id_str) { |p| p.feature_id.to_s }
  end

end
