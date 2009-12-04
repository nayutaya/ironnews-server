# == Schema Information
# Schema version: 20091030050149
#
# Table name: active_forms
#
#  article_id :integer
#  tag        :string
#

# タグ追加API
class AddTagApi < ApiBase
  column :article_id, :type => :integer
  column :tag,        :type => :string

  validates_presence_of :article_id
  validates_presence_of :tag
  # FIXME: article_idの存在を検証
  # FIXME: tagの長さを検証

  def self.from(params)
    return self.new(self.suppress_parameter(params))
  end

  def execute(user_id)
    tag = Tag.get(self.tag)

    tagging = Tagging.find_or_create_by_user_id_and_article_id_and_tag_id(
      user_id, self.article_id, tag.id)

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
