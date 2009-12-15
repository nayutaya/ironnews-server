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
  DivisionTags = %w[鉄道 非鉄].uniq
  CategoryTags = %w[社会 事件事故 痴漢 政治経済 科学技術 車両].uniq
  AreaTags     = %w[北海道 東北 関東 中部 近畿 中国 四国 九州 沖縄 海外].uniq

  belongs_to :article
  belongs_to :division_tag, :class_name => "Tag"
  belongs_to :category_tag1, :class_name => "Tag"
  belongs_to :category_tag2, :class_name => "Tag"
  belongs_to :area_tag1, :class_name => "Tag"
  belongs_to :area_tag2, :class_name => "Tag"

  validates_presence_of :serial
  validates_presence_of :article_id
  validates_uniqueness_of :article_id

  def self.get_serial
    return self.maximum(:serial) || 1
  end

  def self.get_target_taggings(serial, limit)
    return Tagging.all(
      :conditions => ["taggings.id > ?", serial],
      :order      => "taggings.id ASC",
      :limit      => limit)
  end

  # FIXME: 1回のクエリでまとめて取得
  def self.get_division_tags
    return DivisionTags.map { |name| Tag.get(name) }
  end

  # FIXME: 1回のクエリでまとめて取得
  def self.get_category_tags
    return CategoryTags.map { |name| Tag.get(name) }
  end

  # FIXME: 1回のクエリでまとめて取得
  def self.get_area_tags
    return AreaTags.map { |name| Tag.get(name) }
  end

  def self.create_tag_table(article_ids)
    base = article_ids.inject({}) { |memo, article_id|
      memo[article_id] = {}
      memo
    }

    taggings = Tagging.find_all_by_article_id(article_ids)
    result = Tagging.create_tag_frequency_table_from(taggings)

    return base.merge(result)
  end
end
