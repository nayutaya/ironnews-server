class CreateDerivedTaggings < ActiveRecord::Migration
  def self.up
    create_table :derived_taggings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :derived_taggings
  end
end
