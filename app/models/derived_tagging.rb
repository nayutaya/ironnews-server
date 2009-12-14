# == Schema Information
# Schema version: 20091214022821
#
# Table name: derived_taggings
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  serial     :integer       not null, index_derived_taggings_on_serial
#  article_id :integer       not null, index_derived_taggings_on_article_id_and_tag_id(unique) index_derived_taggings_on_article_id
#  tag_id     :integer       not null, index_derived_taggings_on_article_id_and_tag_id(unique) index_derived_taggings_on_tag_id
#

# 導出タグ付け
class DerivedTagging < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag

  validates_presence_of :serial
  validates_presence_of :article_id
  validates_presence_of :tag_id
  validates_uniqueness_of :tag_id, :scope => [:article_id]
end
