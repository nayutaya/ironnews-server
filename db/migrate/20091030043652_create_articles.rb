
class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # タイトル
      t.string   :title,      :null => false, :limit => 200
      # URLホスト部
      t.string   :host,       :null => false, :limit => 100
      # URLパス部
      t.string   :path,       :null => false, :limit => 200
    end
  end

  def self.down
    drop_table :articles
  end
end
