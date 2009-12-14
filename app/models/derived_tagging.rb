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
  DivisionTags = %w[鉄道 非鉄].uniq

  belongs_to :article
  belongs_to :tag

  validates_presence_of :serial
  validates_presence_of :article_id
  validates_presence_of :tag_id
  validates_uniqueness_of :tag_id, :scope => [:article_id]

  def self.get_serial
    return self.maximum(:serial) || 1
  end

  def self.get_target_taggings(serial, limit)
    return Tagging.all(
      :conditions => ["taggings.id > ?", serial],
      :order      => "taggings.id ASC",
      :limit      => limit)
  end

  def self.get_division_tags
    #return [
    #  Tag.get("鉄道"),
    #  Tag.get("非鉄"),
    #]
    return DivisionTags.map { |name| Tag.get(name) }
  end

  def self.create_tag_table(article_ids)
    result = article_ids.inject({}) { |memo, article_id|
      memo[article_id] = Hash.new(0)
      memo
    }

    Tagging.find_all_by_article_id(article_ids).each { |tagging|
      result[tagging.article_id][tagging.tag_id] += 1
    }

    return result
  end

  def self.create_derive_tag_table(tag_table, tag_ids, limit)
    result = {}

    tag_table.each { |article_id, tags|
      result[article_id] = tags.
        select  { |tag_id, count| tag_ids.include?(tag_id) }.
        sort_by { |tag_id, count| [-count, tag_ids.index(tag_id)] }.
        map     { |tag_id, count| tag_id }.
        slice(0, limit)
    }

    return result
  end

  def self.update(limit = 10)
    current_serial = self.get_serial
    taggings       = self.get_target_taggings(current_serial, limit)
    division_tags  = self.get_division_tags
    division_tag_ids = division_tags.map(&:id)
    article_ids      = taggings.map(&:article_id).sort.uniq

    tag_table = self.create_tag_table(article_ids)

    next_serial = taggings.map(&:id).max

    self.delete_all(
      [
        "(derived_taggings.article_id IN (?)) AND (derived_taggings.tag_id IN (?))",
        article_ids,
        division_tag_ids
      ])
    division_tag_table = self.create_derive_tag_table(tag_table, division_tag_ids, 1)
    division_tag_table.each { |article_id, tag_ids|
      tag_ids.each { |tag_id|
        self.create!(
          :serial     => next_serial,
          :article_id => article_id,
          :tag_id     => tag_id)
      }
    }
  end
end
