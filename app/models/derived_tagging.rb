# == Schema Information
# Schema version: 20091215020439
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
  CategoryTags = %w[社会 事件事故 痴漢 政治経済 科学技術 車両].uniq
  AreaTags     = %w[北海道 東北 関東 中部 近畿 中国 四国 九州 沖縄 海外].uniq

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
    result = article_ids.inject({}) { |memo, article_id|
      memo[article_id] = Hash.new(0)
      memo
    }

    Tagging.find_all_by_article_id(article_ids).each { |tagging|
      result[tagging.article_id][tagging.tag_id] += 1
    }

    return result
  end

  def self.create_derive_tag_table(tag_table, candidate_tag_ids, limit)
    return tag_table.inject({}) { |memo, (article_id, tags)|
      memo[article_id] = tags.
        map     { |tag_id, count| [tag_id, count, candidate_tag_ids.index(tag_id)] }.
        reject  { |tag_id, count, pos| pos.nil? }.
        sort_by { |tag_id, count, pos| [-count, pos] }.
        map     { |tag_id, count, pos| tag_id }.
        slice(0, limit)
      memo
    }
  end

  # TODO: テストせよ
  def self.update(limit = 10)
    current_serial = self.get_serial
    taggings       = self.get_target_taggings(current_serial, limit)
    article_ids    = taggings.map(&:article_id).sort.uniq

    tag_table   = self.create_tag_table(article_ids)
    next_serial = taggings.map(&:id).max

    self.delete_all(:article_id => article_ids)

    list  = self.create_division(tag_table)
    list += self.create_category(tag_table)
    list += self.create_area(tag_table)
    list.each { |article_id, tag_id|
      self.create!(
        :serial     => next_serial,
        :article_id => article_id,
        :tag_id     => tag_id)
    }
  end

  # TODO: テストせよ
  def self.create_division(tag_table)
    division_tag_ids = self.get_division_tags.map(&:id)

    result = []
    division_tag_table = self.create_derive_tag_table(tag_table, division_tag_ids, 1)
    division_tag_table.each { |article_id, tag_ids|
      tag_ids.each { |tag_id|
        result << [article_id, tag_id]
      }
    }
    return result
  end

  # TODO: テストせよ
  def self.create_category(tag_table)
    category_tag_ids = self.get_category_tags.map(&:id)

    result = []
    category_tag_table = self.create_derive_tag_table(tag_table, category_tag_ids, 2)
    category_tag_table.each { |article_id, tag_ids|
      tag_ids.each { |tag_id|
        result << [article_id, tag_id]
      }
    }
    return result
  end

  # TODO: テストせよ
  def self.create_area(tag_table)
    area_tag_ids = self.get_area_tags.map(&:id)

    result = []
    area_tag_table = self.create_derive_tag_table(tag_table, area_tag_ids, 2)
    area_tag_table.each { |article_id, tag_ids|
      tag_ids.each { |tag_id|
        result << [article_id, tag_id]
      }
    }
    return result
  end
end
