# == Schema Information
# Schema version: 20091215020439
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

  def self.create_tag_frequency_table
    return self.all.inject({}) { |memo, tagging|
      aid, tid = tagging.article_id, tagging.tag_id
      memo[aid]      ||= {}
      memo[aid][tid] ||= 0
      memo[aid][tid]  += 1
      memo
    }
  end
end
