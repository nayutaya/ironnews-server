# == Schema Information
# Schema version: 20091030050149
#
# Table name: active_forms
#
#  article_id :integer
#  tag        :string
#

# タグ追加API
class AddTagApi < ActiveForm
  column :article_id, :type => :integer
  column :tag,        :type => :string

  validates_presence_of :article_id
  validates_presence_of :tag
  # FIXME: article_idの存在を検証
  # FIXME: tagの長さを検証
end
