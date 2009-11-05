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
  # TODO: テストデータを追加
  # TODO: [関連] Taggingモデルとの関連を追加
  # TODO: [検証] titleが存在すること
  # TODO: [検証] hostが存在すること
  # TODO: [検証] pathが存在すること
  # TODO: [検証] titleが200文字以下であること
  # TODO: [検証] hostが100文字以下であること
  # TODO: [検証] pathが2000文字以下であること
  # TODO: [検証] hostに含まれる英字は小文字であること
end
