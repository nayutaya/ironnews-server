class CreateCombinedTaggings < ActiveRecord::Migration
  def self.up
    create_table :combined_taggings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :combined_taggings
  end
end
