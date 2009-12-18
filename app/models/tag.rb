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

  def self.get(tag, options = {})
    options = options.dup
    create = (options.delete(:create) != false)
    raise(ArgumentError) unless options.empty?

    case tag
    when self    then return tag
    when Integer then return self.find(tag)
    when String  then
      normalized_name = self.normalize(tag)
      if create
        return self.find_or_create_by_name(normalized_name)
      else
        return self.find_by_name(normalized_name)
      end
    else raise(ArgumentError)
    end
  end

  def self.get_by_names(names, options = {})
    options = options.dup
    create = (options.delete(:create) != false)
    raise(ArgumentError) unless options.empty?

    normalized_names = names.map { |name| self.normalize(name) }

    exist_tags = self.find_all_by_name(normalized_names)
    new_tags   =
      if create
        new_tag_names = normalized_names - exist_tags.map(&:name)
        new_tag_names.map { |name| self.create!(:name => name) }
      else
        []
      end

    return (exist_tags + new_tags).sort_by(&:id)
  end
end
