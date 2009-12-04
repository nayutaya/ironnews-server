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
end
