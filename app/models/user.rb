# == Schema Information
# Schema version: 20091030050149
#
# Table name: users
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null
#  name       :string(40)    not null, index_users_on_name(unique)
#

# ユーザ
class User < ActiveRecord::Base
  # TODO: テストデータを追加
  # TODO: [関連] Taggingモデルとの関連を追加
  # TODO: [関連] OpenIdCredentialモデルとの関連を追加
  # TODO: [検証] nameが存在すること
  # TODO: [検証] nameが40文字以下であること
  # TODO: [検証] nameが半角英数字で構成されること
end
