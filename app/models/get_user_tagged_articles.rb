
# ユーザタグ設定済み記事取得API
class GetUserTaggedArticles < ApiBase
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10
end
