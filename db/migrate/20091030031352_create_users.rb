
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # 作成日時
      t.datetime :created_at, :null => false
      # 更新日時
      t.datetime :updated_at, :null => false
      # ユーザ名
      t.string   :name,       :null => false, :limit => 40
      # APIトークン
      t.string   :api_token,  :null => false, :limit => 40
    end

    add_index :users, :name,      :unique => true
    add_index :users, :api_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
