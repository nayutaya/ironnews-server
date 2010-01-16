# == Schema Information
# Schema version: 20091215020439
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
  NameLength      = 4..40 # chars
  NamePattern1    = /\A[a-z0-9_]+\z/
  NamePattern2    = /\A[a-z]/
  ApiTokenLength  = 32
  ApiTokenPattern = /\A[0-9a-f]{#{ApiTokenLength}}\z/

  validates_presence_of :name
  validates_presence_of :api_token
  validates_length_of :name, :in => NameLength, :allow_blank => true
  validates_format_of :name, :with => NamePattern1, :allow_blank => true
  validates_format_of :name, :with => NamePattern2, :allow_blank => true
  validates_format_of :api_token, :with => ApiTokenPattern, :allow_blank => true
  # FIXME: nameの一意性を検証
  # FIXME: api_tokenの一意性を検証

  has_many :open_id_credentials
  has_many :taggings

  def self.create_api_token
    return 32.times.map { rand(16).to_s(16) }.join
  end

  def self.create_unique_api_token
    begin
      token = self.create_api_token
    end while self.exists?(:api_token => token)
    return token
  end
end
