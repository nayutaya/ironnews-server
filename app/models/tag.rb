# == Schema Information
# Schema version: 20091030050149
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

  # TODO: テストデータを追加
  # TODO: [関連] Taggingモデルとの関連を追加

  validates_presence_of :name
  validates_length_of :name, :maximum => NameMaxLength, :allow_blank => true
  # TODO: [検証] nameに含まれる英字は小文字であること
end
