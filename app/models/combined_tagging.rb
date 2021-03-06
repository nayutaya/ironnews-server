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
  # FIXME: Tagモデルに移動する
  DivisionTags = %w[鉄道 非鉄].freeze
  CategoryTags = %w[社会 事件事故 痴漢 政治経済 科学技術 車両 イベント].freeze
  AreaTags     = %w[北海道 東北 関東 中部 近畿 中国 四国 九州 沖縄 海外].freeze

  validates_presence_of :serial
  validates_presence_of :article_id
  validates_uniqueness_of :article_id

  belongs_to :article
  belongs_to :division_tag, :class_name => "Tag"
  belongs_to :category_tag1, :class_name => "Tag"
  belongs_to :category_tag2, :class_name => "Tag"
  belongs_to :area_tag1, :class_name => "Tag"
  belongs_to :area_tag2, :class_name => "Tag"

  def self.get_current_serial
    return self.maximum(:serial) || 1
  end

  def self.get_target_taggings(serial, limit)
    return Tagging.all(
      :conditions => ["taggings.id > ?", serial],
      :order      => "taggings.id ASC",
      :limit      => limit)
  end

  # FIXME: Tagモデルに移動する
  def self.get_division_tags
    return Tag.get_by_names(DivisionTags)
  end

  # FIXME: Tagモデルに移動する
  def self.get_category_tags
    return Tag.get_by_names(CategoryTags)
  end

  # FIXME: Tagモデルに移動する
  def self.get_area_tags
    return Tag.get_by_names(AreaTags)
  end

  def self.create_tag_frequency_table(article_ids)
    return Tagging.
      scoped_by_article_id(article_ids).
      create_tag_frequency_table
  end

  def self.create_combined_tag_table(tag_frequency_table, candidate_tag_ids, limit)
    return tag_frequency_table.mash { |article_id, tag_frequency|
      table = tag_frequency.
        map     { |tag_id, count| [tag_id, count, candidate_tag_ids.index(tag_id)] }.
        reject  { |tag_id, count, pos| pos.nil? }.
        sort_by { |tag_id, count, pos| [-count, pos] }.
        map     { |tag_id, count, pos| tag_id }.
        slice(0, limit)
      [article_id, table]
    }
  end

  # TODO: テストせよ
  def self.incremental_update(limit = 10)
    current_serial = self.get_current_serial
    taggings       = self.get_target_taggings(current_serial, limit)
    article_ids    = taggings.map(&:article_id).sort.uniq
    next_serial    = taggings.map(&:id).max

    division_tag_ids = self.get_division_tags.map(&:id)
    category_tag_ids = self.get_category_tags.map(&:id)
    area_tag_ids     = self.get_area_tags.map(&:id)

    tag_frequency_table = self.create_tag_frequency_table(article_ids)
    division_table      = self.create_combined_tag_table(tag_frequency_table, division_tag_ids, 1)
    category_table      = self.create_combined_tag_table(tag_frequency_table, category_tag_ids, 2)
    area_table          = self.create_combined_tag_table(tag_frequency_table, area_tag_ids, 2)

    article_ids.each { |article_id|
      combined_tagging = self.find_or_initialize_by_article_id(article_id)
      combined_tagging.serial           = next_serial
      combined_tagging.division_tag_id  = division_table[article_id].first
      combined_tagging.category_tag1_id = category_table[article_id].first
      combined_tagging.category_tag2_id = category_table[article_id].second
      combined_tagging.area_tag1_id     = area_table[article_id].first
      combined_tagging.area_tag2_id     = area_table[article_id].second
      combined_tagging.save!
    }
  end
end
