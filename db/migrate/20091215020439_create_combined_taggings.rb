
class CreateCombinedTaggings < ActiveRecord::Migration
  def self.up
    create_table :combined_taggings do |t|
      # 作成日時
      t.datetime :created_at,       :null => false
      # シリアル番号（処理済みタグ付けID）
      t.integer  :serial,           :null => false
      # 記事ID
      t.integer  :article_id,       :null => false
      # 区分タグID
      t.integer  :division_tag_id,  :null => true
      # カテゴリタグID
      t.integer  :category_tag_id1, :null => true
      t.integer  :category_tag_id2, :null => true
      # 地域タグID
      t.integer  :area_tag_id1,     :null => true
      t.integer  :area_tag_id2,     :null => true
    end

    add_index :combined_taggings, :serial
    add_index :combined_taggings, :article_id, :unique => true
    add_index :combined_taggings, :division_tag_id
    add_index :combined_taggings, :category_tag_id1
    add_index :combined_taggings, :category_tag_id2
    add_index :combined_taggings, :area_tag_id1
    add_index :combined_taggings, :area_tag_id2
  end

  def self.down
    drop_table :combined_taggings
  end
end
