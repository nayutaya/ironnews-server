# == Schema Information
# Schema version: 20091030050149
#
# Table name: open_id_credentials
#
#  id           :integer       not null, primary key
#  created_at   :datetime      not null
#  user_id      :integer       not null
#  identity_url :string(200)   not null
#  loggedin_at  :datetime      
#

# OpenIDログイン情報
class OpenIdCredential < ActiveRecord::Base
  # TODO: テストデータを追加
  # TODO: [DB] user_idにインデックスを追加
  # TODO: [DB] identity_urlにユニークインデックスを追加
  # TODO: [関連] Userモデルとの関連を追加
  # TODO: [検証] user_idが存在すること
  # TODO: [検証] identity_urlが存在すること
  # TODO: [検証] identity_urlが200文字以下であること
  # TODO: [検証] identity_urlがURLとして正しいこと
end
