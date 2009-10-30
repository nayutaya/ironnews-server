# == Schema Information
# Schema version: 20091030050149
#
# Table name: tags
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  name       :string(50)    not null
#

# タグ
class Tag < ActiveRecord::Base
  # TODO: テストデータを追加
  # TODO: [DB] nameにユニークインデックスを追加
  # TODO: [関連] Taggingモデルとの関連を追加
  # TODO: [検証] nameが存在すること
  # TODO: [検証] nameが50文字以下であること
  # TODO: [検証] nameに含まれる英字は小文字であること
end
