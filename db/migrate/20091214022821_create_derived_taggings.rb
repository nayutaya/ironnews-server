
class CreateDerivedTaggings < ActiveRecord::Migration
  def self.up
    create_table :derived_taggings do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # 処理済みタグ付けID
      t.integer  :serial,     :null => false
      # 記事ID
      t.integer  :article_id, :null => false
      # タグID
      t.integer  :tag_id,     :null => false
    end

    add_index :derived_taggings, :serial
    add_index :derived_taggings, :article_id
    add_index :derived_taggings, :tag_id
    add_index :derived_taggings, [:article_id, :tag_id], :unique => true
  end

  def self.down
    drop_table :derived_taggings
  end
end
