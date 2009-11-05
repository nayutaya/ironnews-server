
class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # タグ名
      t.string   :name,       :null => false, :limit => 50
    end

    add_index :tags, :name, :unique => true
  end

  def self.down
    drop_table :tags
  end
end
