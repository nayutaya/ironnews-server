# == Schema Information
# Schema version: 20091215020439
#
# Table name: tags
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  name       :string(50)    not null, index_tags_on_name(unique)
#

# タグ
class Tag < ActiveRecord::Base
  NameMaxLength = 50 # chars
  NamePattern   = /\A[^A-Z]*\z/
  Separator     = /[\s\/,　]+/

  has_many :taggings
  has_many :derived_taggings

  validates_presence_of :name
  validates_length_of :name, :maximum => NameMaxLength, :allow_blank => true
  validates_format_of :name, :with => NamePattern, :allow_blank => true
  validates_uniqueness_of :name

  def self.normalize(name)
    return name.downcase.gsub(Separator, "")
  end

  def self.split(names)
    return names.split(Separator).reject(&:empty?)
  end

  def self.get(name, options = {})
    options = options.dup
    create = (options.delete(:create) != false)
    raise(ArgumentError) unless options.empty?

    if name.kind_of?(self)
      return name
    elsif name.kind_of?(Integer)
      return self.find(name)
    end

    normalized_name = self.normalize(name)
    if create
      return self.find_or_create_by_name(normalized_name)
    else
      return self.find_by_name(normalized_name)
    end
  end
end
