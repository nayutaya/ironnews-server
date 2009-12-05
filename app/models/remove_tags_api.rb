
# 複数タグ削除API
class RemoveTagsApi < ApiBase
  column :article_id, :type => :integer
  column :tag1,       :type => :string

  validates_presence_of :article_id
  validates_presence_of :tag1
  # FIXME: article_idの存在を検証
  # FIXME: tag1の長さを検証

  def execute(user_id)
    tag = Tag.get(self.tag1)
    tagging = Tagging.find_by_user_id_and_article_id_and_tag_id(user_id, self.article_id, tag.id)
    tagging.destroy

    return {
      :success => true,
    }
  end
end
