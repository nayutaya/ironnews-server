# == Schema Information
# Schema version: 20091030050149
#
# Table name: taggings
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  user_id    :integer       not null
#  article_id :integer       not null
#  tag_id     :integer       not null
#

# 記事タグ
class Tagging < ActiveRecord::Base
end
