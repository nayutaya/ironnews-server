
# 複数タグ削除API
class RemoveTagsApi < ApiBase
  column :article_id, :type => :integer
  column :tag1,       :type => :string

  validates_presence_of :article_id
  validates_presence_of :tag1
  # FIXME: article_idの存在を検証
  # FIXME: tag1の長さを検証
end
