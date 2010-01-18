
# 地域タグ未設定記事取得APIフォーム
class GetAreaUntaggedArticlesApi < ApiBase
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10
end
