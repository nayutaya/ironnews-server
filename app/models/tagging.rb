# == Schema Information
# Schema version: 20091030050149
#
# Table name: taggings
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  user_id    :integer       not null
#  article_id :integer       not null
#  tag_id     :integer       not null
#

# 記事タグ
class Tagging < ActiveRecord::Base
  # TODO: テストデータを追加
  # TODO: [DB] user_idにインデックスを追加
  # TODO: [DB] article_idにインデックスを追加
  # TODO: [DB] tag_idにインデックスを追加
  # TODO: [DB] [user_id, artcle_id, tag_id]にユニークインデックスを追加
  # TODO: [関連] Userモデルとの関連を追加
  # TODO: [関連] Articleモデルとの関連を追加
  # TODO: [関連] Tagモデルとの関連を追加
  # TODO: [検証] user_idが存在すること
  # TODO: [検証] article_idが存在すること
  # TODO: [検証] tag_idが存在すること
end
