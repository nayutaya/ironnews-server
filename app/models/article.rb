# == Schema Information
# Schema version: 20091215020439
#
# Table name: articles
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  title      :string(200)   not null
#  host       :string(100)   not null, index_articles_on_host_and_path(unique)
#  path       :string(200)   not null, index_articles_on_host_and_path(unique)
#

# 記事
class Article < ActiveRecord::Base
  TitleMaxLength =  200
  HostMaxLength  =  100
  PathMaxLength  = 2000
  HostPattern    = /\A[a-z\d\-]+(\.[a-z\d\-]+)*(:\d+)?\z/

  has_many :taggings, :dependent => :destroy
  has_one :combined_tagging, :dependent => :destroy

  named_scope :division, proc { |tag|
    tag_id = Tag.get(tag).id
    {
      :include    => :combined_tagging,
      :conditions => ["combined_taggings.division_tag_id = ?", tag_id],
    }
  }
  named_scope :category, proc { |tag|
    tag_id = Tag.get(tag).id
    {
      :include    => :combined_tagging,
      :conditions => ["(combined_taggings.category_tag1_id = ?) OR (combined_taggings.category_tag2_id = ?)", tag_id, tag_id],
    }
  }
  named_scope :area, proc { |tag|
    tag_id = Tag.get(tag).id
    {
      :include    => :combined_tagging,
      :conditions => ["(combined_taggings.area_tag1_id = ?) OR (combined_taggings.area_tag2_id = ?)", tag_id, tag_id],
    }
  }
  named_scope :division_tagged_by, proc { |user_id|
    {
      :conditions => [
        "EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_division_tags.map(&:id),
      ],
    }
  }
  named_scope :division_untagged_by, proc { |user_id|
    {
      :conditions => [
        "NOT EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_division_tags.map(&:id),
      ],
    }
  }
  named_scope :category_tagged_by, proc { |user_id|
    {
      :conditions => [
        "EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_category_tags.map(&:id),
      ],
    }
  }
  named_scope :category_untagged_by, proc { |user_id|
    {
      :conditions => [
        "NOT EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_category_tags.map(&:id),
      ],
    }
  }
  named_scope :area_tagged_by, proc { |user_id|
    {
      :conditions => [
        "EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_area_tags.map(&:id),
      ],
    }
  }
  named_scope :area_untagged_by, proc { |user_id|
    {
      :conditions => [
        "NOT EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id IN (?)))",
        user_id,
        CombinedTagging.get_area_tags.map(&:id),
      ],
    }
  }

  validates_presence_of :title
  validates_presence_of :host
  validates_presence_of :path
  validates_length_of :title, :maximum => TitleMaxLength, :allow_blank => true
  validates_length_of :host,  :maximum => HostMaxLength,  :allow_blank => true
  validates_length_of :path,  :maximum => PathMaxLength,  :allow_blank => true
  validates_format_of :host, :with => HostPattern, :allow_blank => true

  def self.join_host_path(host, path)
    return "http://" + host + path
  end

  def self.split_host_path(url)
    # FIXME: httpでない場合は例外を発生させる
    uri  = URI.parse(url)
    host = uri.host
    port = (uri.port == URI::HTTP.default_port ? "" : ":#{uri.port}")
    path = uri.request_uri
    return [host + port, path]
  end

  def self.find_by_url(url)
    host, path = self.split_host_path(url)
    return self.find_by_host_and_path(host, path)
  end

  def url
    return self.class.join_host_path(self.host, self.path)
  end

  def url=(value)
    self.host, self.path = self.class.split_host_path(value)
    return value
  end
end
