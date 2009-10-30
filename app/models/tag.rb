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
end
