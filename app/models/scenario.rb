class Scenario < ActiveRecord::Base

  attr_accessible :description, :name
  belongs_to :feature, :inverse_of => :scenarios
  acts_as_taggable

  has_many :performance_results

  searchable do
    text :name, :stored => true, :boost => 5.0
    text :description
    text :feature_name, :stored => true do
      feature.name
    end
    string :feature_slug, :stored => true do
      feature.slug
    end
    integer :tag_ids, :stored => true, :multiple => true
    string(:feature_id_str) { |p| p.feature_id.to_s }
  end

end
