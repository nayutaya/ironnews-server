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
  # TODO: [関連] Taggingモデルとの関連を追加

  validates_presence_of :title
  validates_presence_of :host
  validates_presence_of :path
  validates_length_of :title, :maximum =>  200, :allow_blank => true
  validates_length_of :host,  :maximum =>  100, :allow_blank => true
  validates_length_of :path,  :maximum => 2000, :allow_blank => true
  # TODO: [検証] hostに含まれる英字は小文字であること
end
