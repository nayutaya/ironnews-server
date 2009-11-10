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
  belongs_to :article
  belongs_to :tag

  validates_presence_of :user_id
  validates_presence_of :article_id
  validates_presence_of :tag_id
  validates_uniqueness_of :tag_id, :scope => [:user_id, :article_id]
end
