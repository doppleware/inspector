class Scenario < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :feature, :inverse_of => :scenarios
end
