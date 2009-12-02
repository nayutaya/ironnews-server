# == Schema Information
# Schema version: 20091030050149
#
# Table name: open_id_credentials
#
#  id           :integer       not null, primary key
#  created_at   :datetime      not null
#  user_id      :integer       not null, index_open_id_credentials_on_user_id
#  identity_url :string(200)   not null, index_open_id_credentials_on_identity_url(unique)
#  loggedin_at  :datetime
#

# OpenIDログイン情報
class OpenIdCredential < ActiveRecord::Base
  IdentityUrlMaxLength = 200

  # TODO: [関連] Userモデルとの関連を追加

  validates_presence_of :user_id
  validates_presence_of :identity_url
  validates_length_of :identity_url, :maximum => IdentityUrlMaxLength, :allow_nil => true
  validates_format_of :identity_url, :with => URI.regexp(%w[http https]), :allow_nil => true
  validates_uniqueness_of :identity_url
end
