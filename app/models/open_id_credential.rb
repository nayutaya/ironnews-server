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
end
