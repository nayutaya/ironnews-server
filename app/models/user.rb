# == Schema Information
# Schema version: 20091030050149
#
# Table name: users
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null
#  name       :string(40)    not null
#  nickname   :string(40)    
#

# ユーザ
class User < ActiveRecord::Base
end
