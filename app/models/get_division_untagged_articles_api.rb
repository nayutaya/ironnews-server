
# 区分タグ未設定記事取得APIフォーム
class GetDivisionUntaggedArticlesApi < ApiBase
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10
end
