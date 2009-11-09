# == Schema Information
# Schema version: 20091030050149
#
# Table name: taggings
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  user_id    :integer       not null, index_taggings_on_user_id_and_article_id_and_tag_id(unique) index_taggings_on_user_id
#  article_id :integer       not null, index_taggings_on_user_id_and_article_id_and_tag_id(unique) index_taggings_on_article_id
#  tag_id     :integer       not null, index_taggings_on_user_id_and_article_id_and_tag_id(unique) index_taggings_on_tag_id
#

# 記事タグ
class Tagging < ActiveRecord::Base
  belongs_to :user
  # TODO: [関連] Articleモデルとの関連を追加
  # TODO: [関連] Tagモデルとの関連を追加

  validates_presence_of :user_id
  validates_presence_of :article_id
  validates_presence_of :tag_id
  # TODO: [検証] [user_id, article_id, tag_id]が一意であること
end
