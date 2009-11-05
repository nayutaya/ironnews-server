
class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # ユーザID
      t.integer  :user_id,    :null => false
      # 記事ID
      t.integer  :article_id, :null => false
      # タグID
      t.integer  :tag_id,     :null => false
    end

    add_index :taggings, :user_id
    add_index :taggings, :article_id
    add_index :taggings, :tag_id
    add_index :taggings, [:user_id, :article_id, :tag_id], :unique => true
  end

  def self.down
    drop_table :taggings
  end
end
