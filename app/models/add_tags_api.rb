
# 複数タグ追加API
class AddTagsApi < ApiBase
  column :article_id, :type => :integer
  column :tag1,       :type => :string
end
