# == Schema Information
# Schema version: 20091215020439
#
# Table name: combined_taggings
#
#  id               :integer       not null, primary key
#  created_at       :datetime      not null
#  serial           :integer       not null, index_combined_taggings_on_serial
#  article_id       :integer       not null, index_combined_taggings_on_article_id(unique)
#  division_tag_id  :integer       index_combined_taggings_on_division_tag_id
#  category_tag_id1 :integer       index_combined_taggings_on_category_tag_id1
#  category_tag_id2 :integer       index_combined_taggings_on_category_tag_id2
#  area_tag_id1     :integer       index_combined_taggings_on_area_tag_id1
#  area_tag_id2     :integer       index_combined_taggings_on_area_tag_id2
#

# 合成タグ付け
class CombinedTagging < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :serial
  validates_presence_of :article_id
  #validates_uniqueness_of :article_id
end
