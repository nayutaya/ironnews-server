# == Schema Information
# Schema version: 20091030050149
#
# Table name: users
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null
#  name       :string(40)    not null, index_users_on_name(unique)
#  api_token  :string(40)    not null, index_users_on_api_token(unique)
#

# ユーザ
class User < ActiveRecord::Base
  NameLength   = 4..40 # chars
  NamePattern1 = /\A[a-z0-9_]+\z/
  NamePattern2 = /\A[a-z]/

  has_many :open_id_credentials
  has_many :taggings

  validates_presence_of :name
  validates_length_of :name, :in => NameLength, :allow_blank => true
  validates_format_of :name, :with => NamePattern1, :allow_blank => true
  validates_format_of :name, :with => NamePattern2, :allow_blank => true
end
