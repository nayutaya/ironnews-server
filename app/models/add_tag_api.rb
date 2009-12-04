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

  def execute(user)
    tagging = Tagging.new
    tagging.user_id    = user.id
    tagging.article_id = self.article_id
    tagging.tag_id     = Tag.find_by_name(self.tag).id
    tagging.save!

    result = {
      :success => true,
      :result  => {
        :article_id => tagging.article_id,
        :tag_id     => tagging.tag_id,
      },
    }
    
    return result
  end
end
