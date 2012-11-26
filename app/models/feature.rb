class Feature < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :name, use: :slugged
  attr_accessible :description, :name, :tag_list
  has_many :scenarios, :inverse_of => :feature
  acts_as_taggable

  searchable do
    text :name, :stored => true, :boost => 5.0    
    text :description
    text :scenarios, :stored => true do
      scenarios.map { |scenario| scenario.name }
    end
  end
  
end
