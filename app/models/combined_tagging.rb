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
#  category_tag1_id :integer       index_combined_taggings_on_category_tag1_id
#  category_tag2_id :integer       index_combined_taggings_on_category_tag2_id
#  area_tag1_id     :integer       index_combined_taggings_on_area_tag1_id
#  area_tag2_id     :integer       index_combined_taggings_on_area_tag2_id
#

# 合成タグ付け
class CombinedTagging < ActiveRecord::Base
  belongs_to :article
  belongs_to :division_tag, :class_name => "Tag"
  belongs_to :category_tag1, :class_name => "Tag"
  belongs_to :category_tag2, :class_name => "Tag"

  validates_presence_of :serial
  validates_presence_of :article_id
  validates_uniqueness_of :article_id
end
