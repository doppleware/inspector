class CreatePerformanceResults < ActiveRecord::Migration
    def change
    create_table :performance_results do |t|
      t.string :build_version
      t.references :scenario      
      t.integer :time
      t.timestamps
    end
  end
end
