class Feature < ActiveRecord::Base
  attr_accessible :description, :name, :tag_list
  has_many :scenarios, :inverse_of => :feature
  acts_as_taggable

  searchable do
    text :name, :description
    text :scenarios do
      scenarios.map { |scenario| scenario.name }
    end
  end
  
end
