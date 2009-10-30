# == Schema Information
# Schema version: 20091030050149
#
# Table name: articles
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  title      :string(200)   not null
#  host       :string(100)   not null
#  path       :string(200)   not null
#

# 記事
class Article < ActiveRecord::Base
end
