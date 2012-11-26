class AddSlugToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :slug, :string
  end
end
