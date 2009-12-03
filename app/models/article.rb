# == Schema Information
# Schema version: 20091030050149
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

  has_many :taggings

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
    path = uri.path
    return [host + port, path]
  end

  def url
    return self.class.join_host_path(self.host, self.path)
  end

  def url=(value)
    self.host, self.path = self.class.split_host_path(value)
    return value
  end
end
