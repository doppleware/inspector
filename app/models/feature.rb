class Feature < ActiveRecord::Base
  attr_accessible :description, :name, :tag_list
  acts_as_taggable

  include PgSearch  

  pg_search_scope :search, against: [:name, :description],
   using: {tsearch: {dictionary: "english"}}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
  
end
